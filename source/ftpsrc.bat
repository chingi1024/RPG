@echo off
set FTPSCRIPT=clubtech.fts
set HOST=%1
set LIB=%2
set USER=%3
set PASS=%4
if "%HOST%"=="" goto usage
if "%LIB%"=="" goto usage
if "%USER%"=="" goto usage
if "%PASS%"=="" goto usage
echo %USER% > %FTPSCRIPT%
echo %PASS% >> %FTPSCRIPT%
echo cd /qsys.lib/qgpl.lib >> %FTPSCRIPT%
echo quote site namefmt 0 >> %FTPSCRIPT%
echo quote rcmd crtsrcpf file(%LIB%/QCLSRC) rcdlen(92) >> %FTPSCRIPT%
echo quote rcmd crtsrcpf file(%LIB%/QRPGLESRC) rcdlen(112) >> %FTPSCRIPT%
echo quote rcmd crtsrcpf file(%LIB%/QSRVSRC) rcdlen(92) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbctestc3.clp %LIB%/QCLSRC.jdbctestc3 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QCLSRC) mbr(jdbctestc3) srctype(clp) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbctestc4.clp %LIB%/QCLSRC.jdbctestc4 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QCLSRC) mbr(jdbctestc4) srctype(clp) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put callresult.rpgle %LIB%/QRPGLESRC.callresult >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(callresult) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put colname.rpgle %LIB%/QRPGLESRC.colname >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(colname) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbc_h.rpgle %LIB%/QRPGLESRC.jdbc_h >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(jdbc_h) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbcr4.rpgle %LIB%/QRPGLESRC.jdbcr4 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(jdbcr4) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbctest.rpgle %LIB%/QRPGLESRC.jdbctest >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(jdbctest) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbctest2.rpgle %LIB%/QRPGLESRC.jdbctest2 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(jdbctest2) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbctest3.rpgle %LIB%/QRPGLESRC.jdbctest3 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(jdbctest3) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbctest4.rpgle %LIB%/QRPGLESRC.jdbctest4 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(jdbctest4) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put mssqltest.rpgle %LIB%/QRPGLESRC.mssqltest >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(mssqltest) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put mysqltest.rpgle %LIB%/QRPGLESRC.mysqltest >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(mysqltest) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put mysqltestc.rpgle %LIB%/QRPGLESRC.mysqltestc >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(mysqltestc) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put oracletest.rpgle %LIB%/QRPGLESRC.oracletest >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QRPGLESRC) mbr(oracletest) srctype(rpgle) >> %FTPSCRIPT%
echo ascii >> %FTPSCRIPT%
echo put jdbcr4.bnd %LIB%/QSRVSRC.jdbcr4 >> %FTPSCRIPT%
echo quote rcmd chgpfm file(%LIB%/QSRVSRC) mbr(jdbcr4) srctype(bnd) >> %FTPSCRIPT%
echo quit >> %FTPSCRIPT%
ftp -s:%FTPSCRIPT% %HOST%
del %FTPSCRIPT%
goto end
:usage
echo.
echo USAGE: ftpsrc HOST LIB USERID PASSWORD
echo.
echo      HOST = FTP server to send to (ex: as400.example.com)
echo       LIB = IBM i library to put source code into (ex: QGPL)
echo    USERID = UserID to log in with
echo  PASSWORD = Password to log in with
echo.
:end
