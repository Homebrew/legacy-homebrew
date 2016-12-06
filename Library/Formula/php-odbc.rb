require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpOdbc <BundledPhpExtensionFormula
  homepage 'http://php.net/odbc'

  configure_args [
    "--with-iodbc=/usr",
    "--with-pdo-odbc=iODBC,/usr"
  ]

  extension_dirs [
    "odbc",
    "pdo_odbc"
  ]

  def patches
    DATA
  end
end

__END__
diff --git a/odbc/config.m4 b/odbc/config.m4
index 361d9de..9a6c0b6 100644
--- a/odbc/config.m4
+++ b/odbc/config.m4
@@ -101,7 +101,7 @@ dnl configure options
 dnl
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(adabas,,
-[  --with-adabas[=DIR]     Include Adabas D support [/usr/local]])
+[  --with-adabas[=DIR]     Include Adabas D support [/usr/local]],no,no)
 
   if test "$PHP_ADABAS" != "no"; then
     AC_MSG_CHECKING([for Adabas support])
@@ -128,7 +128,7 @@ fi
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(sapdb,,
-[  --with-sapdb[=DIR]      Include SAP DB support [/usr/local]])
+[  --with-sapdb[=DIR]      Include SAP DB support [/usr/local]],no,no)
 
   if test "$PHP_SAPDB" != "no"; then
     AC_MSG_CHECKING([for SAP DB support])
@@ -146,7 +146,7 @@ fi
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(solid,,
-[  --with-solid[=DIR]      Include Solid support [/usr/local/solid]])
+[  --with-solid[=DIR]      Include Solid support [/usr/local/solid]],no,no)
 
   if test "$PHP_SOLID" != "no"; then
     AC_MSG_CHECKING(for Solid support)
@@ -171,7 +171,7 @@ fi
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(ibm-db2,,
-[  --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]])
+[  --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]],no,no)
 
   if test "$PHP_IBM_DB2" != "no"; then
     AC_MSG_CHECKING(for IBM DB2 support)
@@ -208,7 +208,7 @@ fi
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(ODBCRouter,,
-[  --with-ODBCRouter[=DIR] Include ODBCRouter.com support [/usr]])
+[  --with-ODBCRouter[=DIR] Include ODBCRouter.com support [/usr]],no,no)
 
   if test "$PHP_ODBCROUTER" != "no"; then
     AC_MSG_CHECKING(for ODBCRouter.com support)
@@ -229,7 +229,7 @@ fi
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(empress,,
 [  --with-empress[=DIR]    Include Empress support [\$EMPRESSPATH]
-                          (Empress Version >= 8.60 required)])
+                          (Empress Version >= 8.60 required)],no,no)
 
   if test "$PHP_EMPRESS" != "no"; then
     AC_MSG_CHECKING(for Empress support)
@@ -253,7 +253,7 @@ if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(empress-bcs,,
 [  --with-empress-bcs[=DIR]
                           Include Empress Local Access support [\$EMPRESSPATH]
-                          (Empress Version >= 8.60 required)])
+                          (Empress Version >= 8.60 required)],no,no)
 
   if test "$PHP_EMPRESS_BCS" != "no"; then
     AC_MSG_CHECKING(for Empress local access support)
@@ -291,7 +291,7 @@ fi
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(birdstep,,
-[  --with-birdstep[=DIR]   Include Birdstep support [/usr/local/birdstep]])
+[  --with-birdstep[=DIR]   Include Birdstep support [/usr/local/birdstep]],no,no)
   
   if test "$PHP_BIRDSTEP" != "no"; then
     AC_MSG_CHECKING(for Birdstep support)
@@ -346,7 +346,7 @@ PHP_ARG_WITH(custom-odbc,,
                           running this configure script:
                               CPPFLAGS=\"-DODBC_QNX -DSQLANY_BUG\"
                               LDFLAGS=-lunix
-                              CUSTOM_ODBC_LIBS=\"-ldblib -lodbc\"])
+                              CUSTOM_ODBC_LIBS=\"-ldblib -lodbc\"],no,no)
 
   if test "$PHP_CUSTOM_ODBC" != "no"; then
     AC_MSG_CHECKING(for a custom ODBC support)
