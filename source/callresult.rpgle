     H DFTACTGRP(*NO) BNDDIR('JDBC')

      /copy jdbc_h

     D conn            s                   like(Connection)
     D prop            s                   like(Properties)
     D stmt            s                   like(CallableStatement)
     D rs              s                   like(ResultSet)
     D rsmd            s                   like(ResultSetMetaData)
     D IsResultSet     s              1n
     D x               s             10i 0
     D msg             s             52a

      /free

         prop = JDBC_Properties();
         JDBC_setProp(prop: 'user'    : 'klemscot' );
         JDBC_setProp(prop: 'password': 'bigboy'   );
         JDBC_setProp(prop: 'prompt'  : 'false');
         JDBC_setProp(prop: 'errors'  : 'full');
         JDBC_setProp(prop: 'naming'  : 'system');

         // This adds the "ISNMAG" library to the end of the
         // library list in the JDBC job.

         JDBC_setProp(prop: 'libraries':'*LIBL,ISNMAG');


         conn = JDBC_ConnProp( 'com.ibm.as400.access.AS400JDBCDriver'
                             : 'jdbc:as400://localhost'
                             : prop );
         JDBC_freeProp(prop);

         if (conn = *NULL);
             return;
         endif;

         stmt = JDBC_PrepCall( conn
                             : '{call union_employees(''UN1'')}');
         IsResultSet = JDBC_execCall( stmt );
         dow IsResultSet;
             rs = JDBC_getResultSet( stmt );
             rsmd = JDBC_getMetaData(rs);

             dow JDBC_nextRow(rs);
                for x = 1 to JDBC_getColCount(rsmd);
                   msg = JDBC_getColName(rsmd: x)
                       + '='
                       + JDBC_getCol(rs: x);
                   dsply msg;
                endfor;
             enddo;

             IsResultSet = JDBC_getMoreResults( stmt );
         enddo;

         JDBC_FreeCAllStmt(stmt);
         JDBC_Close(conn);
         *inlr = *on;

      /end-free
