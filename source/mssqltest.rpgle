      * Sample of accessing an SQL Server database. This was posted to
      * the SystemiNetwork.com forums by Jon Juracich in the following
      * thread:
      * http://www.systeminetwork.com/isnetforums/showthread.php?t=48063
      *
      *  To compile:
      *      - Make sure you change the connection string to the
      *         correct TCP/IP domain name and port for your system.
      *      - Make sure you set the user-id and password appropriately
      *
      *      CRTBNDRPG SQLSERVER SRCFILE(xxx/QRPGLESRC) DBGVIEW(*LIST)
      *                        
      *
     H DFTACTGRP(*NO)
     H OPTION(*NODEBUGIO:*SRCSTMT)
     H BNDDIR('JDBC')

     FQSYSPRT   O    F  132        PRINTER

      /copy jdbc_h

     D getenv          PR              *   EXTPROC('Qp0zGetEnvNoCCSID')
     D  name                           *   VALUE OPTIONS(*STRING)

     D putenv          PR              *   EXTPROC('Qp0zPutEnvNoCCSID')
     D  name                           *   VALUE OPTIONS(*STRING)

     D EnvVal          S            256A   VARYING
     D EnvValChanged   S               N   INZ(*off)
     D p_EnvVal        s               *

     D ErrMsg          s             50A
     D wait            s              1A
     D count           s             10I 0

     D CaseID          s             15A

     D conn            s                   like(Connection)
     D rs              s                   like(ResultSet)
     D prop            s                   like(Properties)
     D prepstm         s                   like(PreparedStatement)

     D JDBCTEST2B      PR                  extpgm('JDBCTEST2B')
     D JDBCTEST2B      PI

      /free
         *inlr = *on;

         // Set up CLASSPATH before starting JVM

         p_envval = getenv('CLASSPATH');
         if (p_envval <> *null);
            EnvVal = %str(p_envval);
         endif;
         if %scan('.:':EnvVal) = *zeros;
           eval EnvVal = '.:' + EnvVal;
           eval EnvValChanged = *on;
         endif;
         if %scan('/sqljdbc.jar':EnvVal) = *zeros;
           eval EnvVal = EnvVal + ':/home/DUBMAPJJ01/sqljdbc.jar';
           eval EnvValChanged = *on;
         endif;
         if EnvValChanged;
           putenv('CLASSPATH=' + EnvVal);
         endif;

         prop = JDBC_Properties();
         JDBC_setProp(prop: 'userName'     : 'scottklement');
         JDBC_setProp(prop: 'password'     : 'bigboy');
         JDBC_setProp(prop: 'databaseName' : 'ClarifyProd');

         conn = JDBC_ConnProp('com.microsoft.sqlserver.jdbc.SQLServerDriver'
                             :'jdbc:sqlserver://myserver.example.com:1433'
                             : prop );
         JDBC_freeProp(prop);

         if (conn = *NULL);
             return;
         endif;

         // Prepare SQL statement string to select case ID

         prepstm = JDBC_prepStmt(conn:
         'SELECT dbo.table_case.id_number ' +
           'FROM  dbo.table_site INNER JOIN ' +
           'dbo.table_case ON dbo.table_site.objid = ' +
           'dbo.table_case.case_reporter2site INNER JOIN ' +
           'dbo.table_x_cat_log ON dbo.table_case.objid = ' +
           'dbo.table_x_cat_log.x_cat_log2case INNER JOIN ' +
           'dbo.table_contact ON dbo.table_case.case_reporter2contact = ' +
           'dbo.table_contact.objid ' +
         'WHERE (dbo.table_site.site_id = ?) AND ' +
           '(dbo.table_contact.last_name = ?)  AND ' +
           '(dbo.table_contact.first_name = ?) AND ' +
           '(dbo.table_contact.phone = ?) AND ' +
           '(dbo.table_x_cat_log.x_case_title = ?) AND' +
           '(dbo.table_x_cat_log.x_c1 = ?) AND ' +
           '(dbo.table_x_cat_log.x_c2 = ?)'   );

         if (prepstm = *NULL);
             jdbc_close(conn);
             return;
         endif;

         // Set SQL parameter values

         JDBC_SetString(prepstm:1:'OH001');
         JDBC_SetString(prepstm:2:'SOX');
         JDBC_SetString(prepstm:3:'PATP');
         JDBC_SetString(prepstm:4:'888-888-2490');
         JDBC_SetString(prepstm:5:
           'Elevated Profile Usage: ' +
           'CAHDTK02_DBEDTKRC01_20060929_M456711_RUSH.' +
           'CABALQUINTO@CA');
         JDBC_SetString(prepstm:6:'AS400');
         JDBC_SetString(prepstm:7:'Distrack');

         // Query the database

         rs = jdbc_ExecPrepQry(prepstm);

         dow (jdbc_nextRow(rs));
             CaseID      = jdbc_getCol(rs: 1);
             except;
         enddo;

         JDBC_FreeResult(rs);
         JDBC_FreePrepStmt(prepstm);
         JDBC_Close(conn);

         return;

      /end-free

     OQSYSPRT   E
     O                       CaseID
