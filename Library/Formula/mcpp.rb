require 'formula'

class Mcpp < Formula
  homepage 'http://mcpp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz'
  sha1 '703356b7c2cd30d7fb6000625bf3ccc2eb977ecb'

  # stpcpy is a macro on OS X; trying to define it as an extern is invalid.
  # Patch from ZeroC fixing EOL comment parsing
  # http://www.zeroc.com/forums/bug-reports/5309-mishap-slice-compilers.html#post23231
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mcpplib"
    system "make install"
  end
end

__END__
diff --git a/src/internal.H b/src/internal.H
index 5e1c19f..39aff8c 100644
--- a/src/internal.H
+++ b/src/internal.H
@@ -390,6 +390,8 @@ extern char * const     work_end;   /* End of work[] buffer         */
 extern char     identifier[];       /* Lastly scanned name          */
 extern IFINFO   ifstack[];          /* Information of #if nesting   */
 extern char     work_buf[];
+extern FILEINFO * sh_file;
+extern int      sh_line;
         /* Temporary buffer for directive line and macro expansion  */
 
 /* main.c   */
@@ -557,6 +559,6 @@ extern void     init_system( void);
 #endif
 #endif
 
-#if HOST_HAVE_STPCPY
+#if HOST_HAVE_STPCPY && !defined(stpcpy)
 extern char *   stpcpy( char * dest, const char * src);
 #endif
diff --git a/src/main.c b/src/main.c
index a438894..8da4b58 100644
--- a/src/main.c
+++ b/src/main.c
@@ -326,6 +326,8 @@ static void     init_main( void)
             = FALSE;
     option_flags.trig = TRIGRAPHS_INIT;
     option_flags.dig = DIGRAPHS_INIT;
+    sh_file = NULL;
+    sh_line = 0;
 }
 
 int     mcpp_lib_main
diff --git a/src/support.c b/src/support.c
index c57eaef..348ede0 100644
--- a/src/support.c
+++ b/src/support.c
@@ -188,7 +188,7 @@ static char *   append_to_buffer(
     size_t      length
 )
 {
-    if (mem_buf_p->bytes_avail < length) {  /* Need to allocate more memory */
+    if (mem_buf_p->bytes_avail < length + 1) {  /* Need to allocate more memory */
         size_t size = MAX( BUF_INCR_SIZE, length);
 
         if (mem_buf_p->buffer == NULL) {            /* 1st append   */
@@ -1722,6 +1722,8 @@ com_start:
                     sp -= 2;
                     while (*sp != '\n')     /* Until end of line    */
                         mcpp_fputc( *sp++, OUT);
+                    mcpp_fputc( '\n', OUT);
+                    wrong_line = TRUE;
                 }
                 goto  end_line;
             default:                        /* Not a comment        */
diff --git a/src/system.c b/src/system.c
index 4759469..4e008fa 100644
--- a/src/system.c
+++ b/src/system.c
@@ -3534,6 +3534,32 @@ void    add_file(
     FILEINFO *      file;
     const char *    too_many_include_nest =
             "More than %.0s%ld nesting of #include";    /* _F_ _W4_ */
+            
+    //
+    // When encoding is UTF-8, skip BOM if present.
+    //
+    if(mbchar == UTF8 && fp != NULL && ftell(fp) == 0)
+    {
+        const unsigned char UTF8_BOM[3] = {0xEF, 0xBB, 0xBF};
+        unsigned char FILE_HEAD[3] = {0, 0, 0};
+        int i;
+        for(i = 0; i < 3; ++i)
+        {
+            FILE_HEAD[i] = getc(fp);
+            if(FILE_HEAD[i] != UTF8_BOM[i])
+            {
+                if(FILE_HEAD[i] == (unsigned char)EOF)
+                {
+                    i--;
+                }
+                for(; i >= 0; --i)
+                {
+                    ungetc(FILE_HEAD[i], fp);
+                }
+                break;
+            }
+        }
+    }
 
     filename = set_fname( filename);    /* Search or append to fnamelist[]  */
     fullname = set_fname( fullname);    /* Search or append to fnamelist[]  */
@@ -3858,6 +3884,9 @@ static int  chk_dirp(
 }
 #endif
 
+FILEINFO*       sh_file;
+int             sh_line;
+
 void    sharp(
     FILEINFO *  sharp_file,
     int         flag        /* Flag to append to the line for GCC   */
@@ -3868,8 +3897,6 @@ void    sharp(
  * else (i.e. 'sharp_file' is NULL) 'infile'.
  */
 {
-    static FILEINFO *   sh_file;
-    static int  sh_line;
     FILEINFO *  file;
     int         line;
 
