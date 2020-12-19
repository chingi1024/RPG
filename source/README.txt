Service Program for Using Java Database Drivers (JDBC) from ILE RPG
by Scott Klement

For more information about this programming example, please see the following
article on System iNetwork:
http://systeminetwork.com/article/jdbc-rpg-unicode-support

-----------------------------------------------------------------------------
UPLOAD INSTRUCTIONS:
-----------------------------------------------------------------------------

This article contains a handy FTP script to help you upload the source code 
from your PC to your IBM i system.  The script is called ftpsrc.bat.  
To run it, type the following from an MS-DOS prompt:

   ftpsrc.bat HOST LIB USER PASSWORD

Where:   HOST = the TCP/IP host name or IP address of your system.
          LIB = library to upload the source code to
         USER = your userid to log on to FTP with
     PASSWORD = your password to log on to FTP with

For example, if you unzipped this code into the C:\Downloads folder on your PC, you'd open a Command Prompt (MS-DOS prompt) and type:

   C:
   cd \Downloads
   ftpsrc.bat as400.example.com qgpl scottk bigboy

This would connect to as400.example.com and log on as userid scottk, password
bigboy.  It would then upload the source code to the QGPL library on that 
system.

Note: There's also an ftpsrc.sh shell script for FreeBSD users.  (Unfortunately
      I don't know if it's compatible with other Unix-like systems such as
      Linux.)

-----------------------------------------------------------------------------
MANUAL UPLOAD INSTRUCTIONS:
-----------------------------------------------------------------------------

If you are unable to use the FTP upload script, you can also upload the source
members using any other tool that you have available.  The members are 
expected to be uploaded as follows:

PC source file        IBM i source file     source member
--------------        -------------------   -------------
callresult.rpgle ->   your-lib/QRPGLESRC    CALLRESULT
colname.rpgle    ->   your-lib/QRPGLESRC    COLNAME
jdbc_h.rpgle     ->   your-lib/QRPGLESRC    JDBC_H
jdbcr4.bnd       ->   your-lib/QSRVSRC      JDBCR4
jdbcr4.rpgle     ->   your-lib/QRPGLESRC    JDBCR4
jdbctest.rpgle   ->   your-lib/QRPGLESRC    JDBCTEST
jdbctest2.rpgle  ->   your-lib/QRPGLESRC    JDBCTEST2
jdbctest3.rpgle  ->   your-lib/QRPGLESRC    JDBCTEST3
jdbctest4.rpgle  ->   your-lib/QRPGLESRC    JDBCTEST4
jdbctestc3.clp   ->   your-lib/QCLSRC       JDBCTESTC3
jdbctestc4.clp   ->   your-lib/QCLSRC       JDBCTESTC4
mssqltest.rpgle  ->   your-lib/QRPGLESRC    MSSQLTEST
mysqltest.rpgle  ->   your-lib/QRPGLESRC    MYSQLTEST
mysqltestc.rpgle ->   your-lib/QRPGLESRC    MYSQLTESTC
oracletest.rpgle ->   your-lib/QRPGLESRC    ORACLETEST

-----------------------------------------------------------------------------
BUILD/COMPILE INSTRUCTIONS:
-----------------------------------------------------------------------------
To build the JDBCR4 service program:

  CRTRPGMOD JDBCR4 SRCFILE(QRPGLESRC) DBGVIEW(*LIST)
     ( Note: this is the JDBCR4.rpgle source member. ) 

  CRTSRVPGM SRVPGM(JDBCR4) EXPORT(*SRCFILE) SRCFILE(QSRVSRC)
     ( Note: this is the JDBCR4.bnd source member. ) 

  CRTBNDDIR BNDDIR(mylib/JDBC)
  ADDBNDDIRE BNDDIR(mylib/JDBC) OBJ((JDBCR4 *SRVPGM))

The other members are examples of utilizing the service program. Please
read the contents of each source member for details on how to compile
and use it.
