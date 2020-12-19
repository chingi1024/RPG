      *  This is a copy of MYSQLTEST (mysqltest.rpgle) except that
      *  it retrieves data by column name instead of column number.
      *                                 Scott Klement, Oct 25, 2007
      *
      *  To Compile:
      *     ** First, you need the JDBCR4 service program. See that
      *        source member for instructions. **
      *     CRTBNDRPG COLNAME SRCFILE(xxx/xxx) DBGVIEW(*LIST)
      *
      *  To Run:
      *     CALL COLNAME PARM('klemscot' 'bigboy')
      *
      *     Replace 'klemscot' with your userid on the MySQL server
      *     and 'bigboy' with your password.
      *
     H DFTACTGRP(*NO) BNDDIR('JDBC')

     FQSYSPRT   O    F  132        PRINTER

      /copy jdbc_h

     D COLNAME         PR                  extpgm('COLNAME')
     D    userid                     15A   const
     D    passwrd                    15A   const
     D COLNAME         PI
     D    userid                     15A   const
     D    passwrd                    15A   const

     D CreateDb        PR             1N
     D CreateTable     PR             1N
     D InsertRec       PR             1N
     D   ItemNo                       5P 0 value
     D   Count                       10I 0 value
     D   LastChg                       Z   const
     D   LastSold                      d   const datfmt(*ISO)
     D   TimeTest                      t   const timfmt(*HMS)
     D   Price                        7P 2 value
     D   Description                 25A   const varying

     D conn            s                   like(Connection)
     D ErrMsg          s             50A
     D wait            s              1A
     D count           s             10I 0
     D rs              s                   like(ResultSet)
     D itemNo          s              5P 0
     D Desc            s             25A


      /free
         *inlr = *on;

         conn = MySql_Connect( 'red.klements.com'
                             : 'mysql'
                             : %trim(userid)
                             : %trim(passwrd) );

          // Delete/Create a test database for demonstration

         if (CreateDB() = *OFF);
             jdbc_close(conn);
             dsply ErrMsg '' wait;
             return;
         endif;

          // Create the RpgTest table in that database

         if (CreateTable() = *OFF);
             dsply ErrMsg '' wait;
             jdbc_close(conn);
             return;
         endif;

          // Insert a few records

         InsertRec( 10001: 887: %timestamp(): d'2005-01-02': t'12.34.56'
                  : 1003.05: 'Testing Product 10001');
         InsertRec( 10002: 888: %timestamp(): d'2005-03-04': t'18.34.43'
                  : 1003.05: 'Testing Product 10002');
         InsertRec( 10003: 999: %timestamp(): d'2001-12-29': t'18.34.43'
                  : 12.58: 'Testing Product 10003');

          // Query the records

         rs = jdbc_ExecQry( conn : 'Select ItemNo,Description'
                                 + '  from RpgTest'
                                 + '  where LastSold < DATE("2003-01-01")'
                                 );
         dow (jdbc_nextRow(rs));
             ItemNo = %int(jdbc_getColByName(rs: 'ItemNo'));
             Desc   = jdbc_getColByName(rs: 'Description'); 
             except;
         enddo;

         jdbc_freeResult(rs);

         jdbc_close(conn);
         return;
      /end-free

     OQSYSPRT   E
     O                       ItemNo        Z      5
     O                       Desc                32


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * CreateDB():  Create a scratch database called TESTSCK
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P Createdb        b
     D createdb        PI             1N
     D rc              s             10I 0
      /free

        // Get rid of database if it exists

         JDBC_ExecUpd( conn : 'Drop Database testsck' );

        // Create new TESTSCK database to test stuff with.

         rc = JDBC_ExecUpd( conn : 'Create Database testsck'
                                 +       ' Default Character Set utf8'
                                 +       ' Collate utf8_bin' );
         if (rc < 0);
            ErrMsg = 'Unable to CREATE database';
            return *OFF;
         endif;

        // Set TESTSCK as the active database

         rc = JDBC_ExecUpd( conn : 'Use testsck' );
         if (rc < 0);
            ErrMsg = 'Unable to USE database';
            return *OFF;
         endif;

         return *ON;
      /end-free
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * CreateTable():  Create a Table named RPGTEST
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P CreateTable     b
     D CreateTable     PI             1N
     D rc              s             10I 0
      /free

        rc = JDBC_ExecUpd( conn : 'Create Table RpgTest'
                                + '('
                                + '  ItemNo Dec(5,0) Not Null, '
                                + '  Count Int Not Null, '
                                + '  LastChg Timestamp '
                                + '       Default CURRENT_TIMESTAMP, '
                                + '  LastSold Date Default Null, '
                                + '  TimeTest Time Default Null, '
                                + '  Price Dec(7,2) Not Null, '
                                + '  Description VarChar(25) not Null, '
                                + '  Primary Key( ItemNo )'
                                + ')' );
         if (rc < 0);
            ErrMsg = 'Unable to CREATE table';
            return *OFF;
         else;
            return *ON;
         endif;
      /end-free
     P                 E


      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * InsertRec():  Insert record into RPGTEST table
      *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P InsertRec       b
     D InsertRec       PI             1N
     D   ItemNo                       5P 0 value
     D   Count                       10I 0 value
     D   LastChg                       Z   const
     D   LastSold                      d   const datfmt(*ISO)
     D   TimeTest                      t   const timfmt(*HMS)
     D   Price                        7P 2 value
     D   Description                 25A   const varying
     D rc              s             10I 0
     D stmt            s                   like(PreparedStatement)
      /free

          stmt = JDBC_PrepStmt(conn : 'Insert Into RpgTest '
                                  + '(ItemNo, Count, LastChg, LastSold, '
                                  + 'TimeTest, Price, Description)'
                                  + ' values (?,?,?,?,?,?,?)' );
          if (stmt = *NULL);
             ErrMsg = 'Prepare Statement failed!';
             return *OFF;
          endif;

          JDBC_setDecimal  (stmt: 1: ItemNo);
          JDBC_setInt      (stmt: 2: Count);
          JDBC_setTimeStamp(stmt: 3: LastChg );
          JDBC_setDate     (stmt: 4: LastSold );
          JDBC_setTime     (stmt: 5: TimeTest );
          JDBC_setDecimal  (stmt: 6: Price );
          JDBC_setString   (stmt: 7: Description );

          rc = JDBC_ExecPrepUpd( stmt );
          if (rc < 0);
             ErrMsg = 'Execute Prepared Failed!';
             return *OFF;
          endif;

          JDBC_FreePrepStmt( stmt );

          return *ON;
      /end-free
     P                 E
