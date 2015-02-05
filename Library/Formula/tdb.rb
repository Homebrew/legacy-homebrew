class Tdb < Formula
  homepage "http://sourceforge.net/projects/tdb/"
  url "https://downloads.sourceforge.net/project/tdb/tdb/1.0.6/tdb-1.0.6.tar.gz"
  sha1 "d1876522f1b8ffa8cf844a1f6605e0c32d387a7a"

  depends_on "gdbm" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--host=6x86"
    system "make", "install"
  end

  # older versions of the compiler allowed you to have a printf that
  # spaned multiple lines, now that's no longer the case. There is a
  # patch submitted upstream for this but it doesn't seem like it will
  # ever be applied: http://sourceforge.net/p/tdb/patches/6/ as it
  # dates back to 2003, and still hasn't been.
  patch :DATA
end
__END__
diff --git a/tdbtool.c b/tdbtool.c
index b4fa92a..237a825 100644
--- a/tdbtool.c
+++ b/tdbtool.c
@@ -169,23 +169,21 @@ static void print_data(unsigned char *buf,int len)
 
 static void help(void)
 {
-	printf("
-tdbtool: 
-  create    dbname     : create a database
-  open      dbname     : open an existing database
-  erase                : erase the database
-  dump      dumpname   : dump the database as strings
-  insert    key  data  : insert a record
-  store     key  data  : store a record (replace)
-  show      key        : show a record by key
-  delete    key        : delete a record by key
-  list                 : print the database hash table and freelist
-  free                 : print the database freelist
-  1 | first            : print the first record
-  n | next             : print the next record
-  q | quit             : terminate
-  \\n                   : repeat 'next' command
-");
+	printf(" tdbtool: \n"
+  "create    dbname     : create a database\n"
+  "open      dbname     : open an existing database\n"
+  "erase                : erase the database\n"
+  "dump      dumpname   : dump the database as strings\n"
+  "insert    key  data  : insert a record\n"
+  "store     key  data  : store a record (replace)\n"
+  "show      key        : show a record by key\n"
+  "delete    key        : delete a record by key\n"
+  "list                 : print the database hash table and freelist\n"
+  "free                 : print the database freelist\n"
+  "1 | first            : print the first record\n"
+  "n | next             : print the next record\n"
+  "q | quit             : terminate\n"
+  "\\n                   : repeat 'next' command\n");
 }
 
 static void terror(char *why)
