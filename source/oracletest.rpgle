      * Sample of accessing an Oracle database. This was posted to
      * the SystemiNetwork.com forums by Vincent Taquin
      *
      *  To compile:
      *      - Make sure you change the connection string to the
      *         correct TCP/IP domain name and port for your system.
      *      - Make sure you set the user-id and password appropriately
      *
      *      CRTBNDRPG ORACLETEST SRCFILE(xxx/QRPGLESRC) DBGVIEW(*LIST)
      *                        
      *
     H DFTACTGRP(*NO)
     H OPTION(*NODEBUGIO:*SRCSTMT)
     H BNDDIR('JDBC')

     FQSYSPRT   O    F  132        PRINTER
   
     D ORACLETEST      PR                  ExtPgm('ORACLETEST')
     D   userid                      32a   const
     D   passwrd                     32a   const
     D ORACLETEST      PI
     D   userid                      32a   const
     D   passwrd                     32a   const

      /copy jdbc_h

     D ErrMsg          s             50A
     D wait            s              1A
     D count           s             10I 0

     D CustNo          s             10A
     D Name            s             30A
     D City            s             20A

     D conn            s                   like(Connection)
     D rs              s                   like(ResultSet)
     D prop            s                   like(Properties)

      /free
         *inlr = *on;

         // Connect to Oracle database
         //  change the jdbc:oracle string to reference your IP address
         //  and your database name!

         prop = JDBC_Properties();
         JDBC_setProp(prop: 'user'         : %trim(userid) );
         JDBC_setProp(prop: 'password'     : %trim(passwrd) );

         conn = JDBC_ConnProp('oracle.jdbc.OracleDriver'
                          :'jdbc:oracle:thin:@123.123.123.123:1521:myDataBase'
                          : prop );
         JDBC_freeProp(prop);

         if (conn = *NULL);
             return;
         endif;

         // Prepare SQL statement to list customer info

         rs = JDBC_ExecQry(conn: 'Select custno, name, city
                                    from customer_table');

         dow (jdbc_nextRow(rs));
             custno = jdbc_getCol(rs: 1);
             name   = jdbc_getCol(rs: 2);
             city   = jdbc_getCol(rs: 3);
             except;
         enddo;

         JDBC_FreeResult(rs);
         JDBC_Close(conn);

         return;

      /end-free

     OQSYSPRT   E
     O                       CustNo
     O                       Name
     O                       City
