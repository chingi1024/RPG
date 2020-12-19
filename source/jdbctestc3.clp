             PGM

             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(9) +
                          VALUE('SQLSERVER')
             DCL        VAR(&DRIVER) TYPE(*CHAR) LEN(128)
             DCL        VAR(&URL)    TYPE(*CHAR) LEN(128)
             DCL        VAR(&DATABASE) TYPE(*CHAR) LEN(30)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(15)
             DCL        VAR(&PASSWRD) TYPE(*CHAR) LEN(15)
             DCL        VAR(&SQL)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PGMNAM) TYPE(*CHAR) LEN(10) +
                          VALUE(JDBCTEST3)
 /* ERROR PROCESSING VARIABLES */
             DCL        VAR(&ERRBYTES)   TYPE(*CHAR) LEN(4) +
                          VALUE(X'00000000')
             DCL        VAR(&ERROR)      TYPE(*LGL)  VALUE('0')
             DCL        VAR(&MSGKEY)     TYPE(*CHAR) LEN(04)
             DCL        VAR(&MSGTYP)     TYPE(*CHAR) LEN(10) +
                          VALUE('*DIAG')
             DCL        VAR(&MSGTYPCTR)  TYPE(*CHAR) LEN(4) +
                          VALUE(X'00000001')
             DCL        VAR(&PGMMSGQ)    TYPE(*CHAR) LEN(10) +
                          VALUE('*')
             DCL        VAR(&STKCTR)     TYPE(*CHAR) LEN(4) +
                          VALUE(X'00000001')

 /* DEFAULT MONITORING */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERRPROC))

 /********************************************************************/
 /* MAINLINE ROUTINE                                                 */
 /********************************************************************/

             IF         COND(&SYSTEM = 'SQLSERVER') THEN(DO)
              CHGVAR     VAR(&DRIVER) +
                          VALUE('com.microsoft.sqlserver.jdbc.SQLServ+
                          erDriver')
              CHGVAR     VAR(&URL) +
                          VALUE('jdbc:sqlserver://hostname:1433')
              CHGVAR     VAR(&DATABASE) VALUE('fdcorderentry')
              CHGVAR     VAR(&USERID) VALUE('fdcorderentry')
              CHGVAR     VAR(&PASSWRD) VALUE('******')
              CHGVAR     VAR(&SQL) VALUE('select [action], [entity], +
                          [message] from dbo.EntityStagingTest')
         /*   DMPCLPGM  */
             ENDDO
             ELSE       CMD(DO)
              CHGVAR &DRIVER   'com.ibm.as400.access.AS400JDBCDriver'
              CHGVAR &URL      'jdbc:as400://S102LKZM:446/S102LKZM'
              CHGVAR &USERID   'QRLJ'
              CHGVAR &PASSWRD  '*****'
              CHGVAR &SQL      'SELECT * FROM LIB.FILE'
             ENDDO

             CALL       PGM(&PGMNAM) PARM(&DRIVER &URL &DATABASE +
                          &USERID &PASSWRD &SQL)


 END:        RETURN

 /********************************************************************/
 /* ERROR PROCESSING ROUTINE                                         */
 /********************************************************************/
 ERRPROC:    IF         COND(&ERROR) THEN(GOTO CMDLBL(ERRDONE))
             ELSE       CMD(CHGVAR VAR(&ERROR) VALUE('1'))

 /* MOVE ALL *DIAG MESSAGES TO THE PREVIOUS PROGRAM QUEUE */
             CALL       PGM(QMHMOVPM) PARM(&MSGKEY &MSGTYP +
                          &MSGTYPCTR &PGMMSGQ &STKCTR &ERRBYTES)

 /* RESEND LAST *ESCAPE MESSAGE */
 ERRDONE:    CALL       PGM(QMHRSNEM) PARM(&MSGKEY &ERRBYTES)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               SNDPGMMSG  MSGID(CPF3CF2) MSGF(QCPFMSG) +
                          MSGDTA('QMHRSNEM') MSGTYPE(*ESCAPE)
               MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
