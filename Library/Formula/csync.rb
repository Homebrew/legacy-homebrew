require 'formula'

class Csync < Formula
  homepage 'http://www.csync.org/'
  url 'http://www.csync.org/files/csync-0.49.9.tar.gz'
  sha1 'fd7df6c13aa6fc6de74cb48c2ac35ad11f6d895d'

  # Note: HEAD requires git:// protocol, https:// does not work.
  head 'git://git.csync.org/projects/csync.git'

  depends_on 'doxygen' => :build
  depends_on 'cmake' => :build
  depends_on 'check' => :build
  depends_on 'sqlite'
  depends_on 'iniparser'
  depends_on 'argp-standalone'
  depends_on 'libssh' => :optional

  if build.head?
    # Log4c and libsmbclient are optional in HEAD. See
    # http://git.csync.org/projects/csync.git/commit/?id=13f05db93484ad6100c1987d11e7a6d33bd5d754
    # http://git.csync.org/projects/csync.git/commit/?id=f064dbcde4e25cb4661be77a76be7279946be3d6
    depends_on 'log4c' => :optional
    depends_on 'samba' => :optional
  else
    depends_on 'log4c'
    depends_on 'samba'
  end

  def patches
    DATA
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
      Dir['modules/CMakeFiles/*/link.txt'].each do |f|
        inreplace f do |s|
          s.gsub! '-o', "../src/libcsync.dylib ../src/std/libcstdlib.a -o"
        end
      end
      # Now we can make and install.
      system "make all"
      system "make install"
    end
  end

  def test
    system "csync", "-V"
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
