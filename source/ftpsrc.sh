#!/bin/sh
FTPSCRIPT=clubtech.fts
HOST=$1
LIB=$2
USER=$3
PASS=$4

usage() {
   echo " "
   echo "USAGE: ./ftpsrc.sh HOST LIB USERID PASSWORD"
   echo " "
   echo "     HOST = FTP server to send to (ex: as400.example.com)"
   echo "      LIB = IBM i library to put source code into (ex: QGPL)"
   echo "   USERID = UserID to log in with"
   echo " PASSWORD = Password to log in with"
   echo " "
}

buildscript() {
   echo "user $USER $PASS"
   echo "cd /qsys.lib/qgpl.lib"
   echo "quote site namefmt 0"
   echo "quote rcmd crtsrcpf file($LIB/QCLSRC) rcdlen(92)"
   echo "quote rcmd crtsrcpf file($LIB/QRPGLESRC) rcdlen(112)"
   echo "quote rcmd crtsrcpf file($LIB/QSRVSRC) rcdlen(92)"
   echo "quote rcmd crtsrcpf file($LIB/QjavaSRC) rcdlen(92)"
   echo "ascii"
   echo "put jdbctestc3.clp $LIB/QCLSRC.jdbctestc3"
   echo "quote rcmd chgpfm file($LIB/QCLSRC) mbr(jdbctestc3) srctype(clp)"
   echo "ascii"
   echo "put jdbctestc4.clp $LIB/QCLSRC.jdbctestc4"
   echo "quote rcmd chgpfm file($LIB/QCLSRC) mbr(jdbctestc4) srctype(clp)"
   echo "ascii"
   echo "put callresult.rpgle $LIB/QRPGLESRC.callresult"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(callresult) srctype(rpgle)"
   echo "ascii"
   echo "put colname.rpgle $LIB/QRPGLESRC.colname"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(colname) srctype(rpgle)"
   echo "ascii"
   echo "put jdbc_h.rpgle $LIB/QRPGLESRC.jdbc_h"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(jdbc_h) srctype(rpgle)"
   echo "ascii"
   echo "put jdbcr4.rpgle $LIB/QRPGLESRC.jdbcr4"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(jdbcr4) srctype(rpgle)"
   echo "ascii"
   echo "put jdbctest.rpgle $LIB/QRPGLESRC.jdbctest"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(jdbctest) srctype(rpgle)"
   echo "ascii"
   echo "put jdbctest2.rpgle $LIB/QRPGLESRC.jdbctest2"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(jdbctest2) srctype(rpgle)"
   echo "ascii"
   echo "put jdbctest3.rpgle $LIB/QRPGLESRC.jdbctest3"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(jdbctest3) srctype(rpgle)"
   echo "ascii"
   echo "put jdbctest4.rpgle $LIB/QRPGLESRC.jdbctest4"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(jdbctest4) srctype(rpgle)"
   echo "ascii"
   echo "put mssqltest.rpgle $LIB/QRPGLESRC.mssqltest"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(mssqltest) srctype(rpgle)"
   echo "ascii"
   echo "put mysqltest.rpgle $LIB/QRPGLESRC.mysqltest"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(mysqltest) srctype(rpgle)"
   echo "ascii"
   echo "put mysqltestc.rpgle $LIB/QRPGLESRC.mysqltestc"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(mysqltestc) srctype(rpgle)"
   echo "ascii"
   echo "put oracletest.rpgle $LIB/QRPGLESRC.oracletest"
   echo "quote rcmd chgpfm file($LIB/QRPGLESRC) mbr(oracletest) srctype(rpgle)"
   echo "ascii"
   echo "put jdbcr4.bnd $LIB/QSRVSRC.jdbcr4"
   echo "quote rcmd chgpfm file($LIB/QSRVSRC) mbr(jdbcr4) srctype(bnd)"
   echo "ascii"
   echo "put testMySql.java $LIB/QjavaSRC.testMySql"
   echo "quote rcmd chgpfm file($LIB/QjavaSRC) mbr(testMySql) srctype(java)"
   echo "quit"
}

if test "x$HOST" = "x" -o "x$LIB" = "x" -o "x$USER" = "x" -o "x$PASS" = "x"; then
  usage
  exit 1
fi

buildscript > $FTPSCRIPT
ftp -n $HOST < $FTPSCRIPT
rm -f $FTPSCRIPT
