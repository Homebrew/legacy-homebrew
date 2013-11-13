require 'formula'

class Osxfuse < Formula
  homepage 'http://osxfuse.github.io'
  url 'https://github.com/osxfuse/osxfuse.git', :tag => 'osxfuse-2.6.1_1'

  head 'https://github.com/osxfuse/osxfuse.git', :branch => 'osxfuse-2'

  bottle do
    sha1 'cecee3f4d3d790d4277a4520b988cd8d26eeca90' => :mountain_lion
    sha1 'f2e691264528e5364bc2dede5e8874a75f657b6e' => :lion
    sha1 '40e05305257de14c5dda8058de5ad14440e87dde' => :snow_leopard
  end

  depends_on :macos => :snow_leopard
  depends_on :xcode
  depends_on :autoconf
  depends_on :automake
  depends_on 'gettext' => :build
  depends_on 'libtool' => :build

  def install
    # Do not override Xcode build settings
    ENV.remove_cc_etc

    if MacOS::Xcode.provides_autotools?
      # Xcode version of aclocal does not respect ACLOCAL_PATH
      ENV['ACLOCAL'] = 'aclocal ' + ENV['ACLOCAL_PATH'].split(':').map {|p| '-I' + p}.join(' ')
    end

    system "./build.sh", "-t", "homebrew", "-f", prefix
  end

  def patches
    # Don't lack fuse.pc
    DATA
  end

  def caveats; <<-EOS.undent
    If upgrading from a previous version of osxfuse, the previous kernel extension
    will need to be unloaded before installing the new version. First, check that
    no FUSE-based file systems are running:

      mount -t osxfusefs

    Unmount all FUSE file systems and then unload the kernel extension:

      sudo kextunload -b com.github.osxfuse.filesystems.osxfusefs

    The new osxfuse file system bundle needs to be installed by the root user:

      sudo /bin/cp -RfX #{prefix}/Library/Filesystems/osxfusefs.fs /Library/Filesystems
      sudo chmod +s /Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs
    EOS
  end
end

__END__
diff --git
diff --git a/fuse/Makefile.am b/fuse/Makefile.am
index 210cb48..8f02307 100644
--- a/fuse/Makefile.am
+++ b/fuse/Makefile.am
@@ -4,7 +4,6 @@ SUBDIRS = @subdirs@ @subdirs2@
 
 EXTRA_DIST =			\
 	fuse.pc.in		\
-	osxfuse.pc.in		\
 	README*			\
 	Filesystems		\
 	FAQ			\
@@ -14,10 +13,6 @@ EXTRA_DIST =			\
 
 pkgconfigdir = @pkgconfigdir@
 
-if DARWIN
-pkgconfig_DATA = osxfuse.pc
-else
 pkgconfig_DATA = fuse.pc
-endif
 
 $(pkgconfig_DATA): config.status
diff --git a/fuse/configure.in b/fuse/configure.in
index df12cc4..1e32f82 100644
--- a/fuse/configure.in
+++ b/fuse/configure.in
@@ -103,11 +103,7 @@ AM_CONDITIONAL(LINUX, test "$arch" = linux)
 AM_CONDITIONAL(BSD, test "$arch" = bsd)
 AM_CONDITIONAL(DARWIN, test "$arch" = darwin)
 
-if test "$arch" = darwin; then
-	fuse_pc=osxfuse.pc
-else
-	fuse_pc=fuse.pc
-fi
+fuse_pc=fuse.pc
 
 AC_CONFIG_FILES([$fuse_pc Makefile lib/Makefile util/Makefile example/Makefile include/Makefile])
 AC_OUTPUT
diff --git a/fuse/fuse.pc.in b/fuse/fuse.pc.in
index 9f98892..f8a1cb7 100644
--- a/fuse/fuse.pc.in
+++ b/fuse/fuse.pc.in
@@ -4,7 +4,7 @@ libdir=@libdir@
 includedir=@includedir@
 
 Name: fuse
-Description: Filesystem in Userspace
+Description: OSXFUSE
 Version: @VERSION@
-Libs: -L${libdir} -lfuse @libfuse_libs@
-Cflags: -I${includedir}/fuse -D_FILE_OFFSET_BITS=64
+Libs: -L${libdir} -losxfuse @libfuse_libs@
+Cflags: -I${includedir}/osxfuse/fuse -D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE
C_OUTPUT
