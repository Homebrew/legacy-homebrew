require 'formula'

class Csync < Formula
  homepage 'http://www.csync.org/'

  stable do
    url 'http://www.csync.org/files/csync-0.49.9.tar.gz'
    sha1 'fd7df6c13aa6fc6de74cb48c2ac35ad11f6d895d'

    depends_on 'log4c'
    depends_on 'samba'
  end

  head do
    url 'git://git.csync.org/projects/csync.git'
    # Log4c and libsmbclient are optional in HEAD.
    depends_on 'log4c' => :optional
    depends_on 'samba' => :optional
  end

  depends_on 'check' => :build
  depends_on 'cmake' => :build
  depends_on 'doxygen' => [:build, :optional]
  depends_on 'argp-standalone'
  depends_on 'iniparser'
  depends_on 'sqlite'
  depends_on 'libssh' => :optional

  depends_on :macos => :lion

  #
  # Stable version requires inline patch
  #
  stable do
  patch :DATA
  end

  #
  # Head version requires patch to fix smbc_utimes
  #
  head do
  patch "--- a/modules/csync_smb.c
+++ b/modules/csync_smb.c
@@ -414,7 +414,7 @@ static int _chown(const char *uri, uid_t owner, gid_t group) {
 }

 static int _utimes(const char *uri, const struct timeval *times) {
-  return smbc_utimes(uri, (struct timeval *) times);
+  return smbc_utimes(uri, (void *) times);
 }

 static struct csync_vio_capabilities_s _smb_capabilities = {
"
  #
  # Head version requires patch to ignore iconv ... this can't be right!
  #
    patch "--- a/src/std/c_string.c
+++ b/src/std/c_string.c
@@ -87,6 +87,8 @@ enum iconv_direction { iconv_from_native, iconv_to_native };

 static char *c_iconv(const char* str, enum iconv_direction dir)
 {
+    return c_strdup(str);
+/*
 #ifdef HAVE_ICONV_CONST
     const char *in = str;
 #else
@@ -128,6 +130,7 @@ static char *c_iconv(const char* str, enum iconv_direction dir)
   }

   return out;
+ */
 }
 #endif /* defined(HAVE_ICONV) && defined(WITH_ICONV) */
"
  end

  def install
    mkdir 'build' unless build.head?
    cd 'build' do
    system "cmake", "..", *std_cmake_args
    # We need to run make csync first to make the "core",
    # or the build system will freak out and try to link
    # modules against core functions that aren't compiled
    # yet. We also have to patch "link.txt" for all module
    # targets. This should probably be reported upstream.
    system "make csync"
    inreplace Dir['modules/CMakeFiles/*/link.txt'] do |s|
    s.gsub! '-o', "../src/libcsync.dylib ../src/std/libcstdlib.a -o"
    end
    # Now we can make and install.
    system "make all"
      system "make install"
    end
  end

  test do
    system bin/"csync", "-V"
  end
end

__END__
--- a/src/csync_propagate.c 2012-07-01 13:12:12.000000000 +0200
+++ b/src/csync_propagate.c 2012-07-01 13:12:59.000000000 +0200
@@ -101,10 +101,6 @@
   /* Open the source file */
   ctx->replica = srep;
   flags = O_RDONLY|O_NOFOLLOW;
-  /* O_NOATIME can only be set by the owner of the file or the superuser */
-  if (st->uid == ctx->pwd.uid || ctx->pwd.euid == 0) {
-    flags |= O_NOATIME;
-  }
   sfp = csync_vio_open(ctx, suri, flags, 0);
   if (sfp == NULL) {
     if (errno == ENOMEM) {
