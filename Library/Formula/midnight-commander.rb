require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.3.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  sha256 '445f286652b85c3e8e87839bad64c28ad2dc80661778571a0b59c2b920ef60ac'

  head 'https://github.com/MidnightCommander/mc.git'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 's-lang'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Patch is an attempt to fix occasional fork bombs reported in #8587.
  # If it works, remove @ mc-4.8.4.  The patch is taken from their repo:
  # https://www.midnight-commander.org/raw-attachment/ticket/2806/2806.3.diff
  def patches
    DATA if ARGV.build_head?
  end

  def install
    if ARGV.build_head?
      ENV['GIT_DIR'] = cached_download/'.git'
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      system './autogen.sh'
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=slang"
    system "make install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 4b39f16..344e779 100644
--- a/configure.ac
+++ b/configure.ac
@@ -481,10 +481,15 @@ AC_SUBST(LIBS)
 dnl Libraries used only when building the mc binary
 AC_SUBST(MCLIBS)
 
-
 EXTHELPERSDIR=${prefix}/libexec/${PACKAGE}/ext.d
 AC_SUBST(EXTHELPERSDIR)
 
+EXTFSHELPERSDIR=${prefix}/libexec/${PACKAGE}/extfs.d
+AC_SUBST(EXTFSHELPERSDIR)
+
+FISHHELPERSDIR=${prefix}/libexec/${PACKAGE}/fish
+AC_SUBST(FISHHELPERSDIR)
+
 MAN_DATE="$(LC_ALL=C date "+%B %Y")"
 AC_SUBST(MAN_DATE)
 
diff --git a/src/vfs/extfs/helpers/Makefile.am b/src/vfs/extfs/helpers/Makefile.am
index 6e30e17..44ecb71 100644
--- a/src/vfs/extfs/helpers/Makefile.am
+++ b/src/vfs/extfs/helpers/Makefile.am
@@ -1,4 +1,4 @@
-extfsdir = $(libexecdir)/@PACKAGE@/extfs.d
+extfsdir = $(EXTFSHELPERSDIR)
 
 EXTFSCONFFILES = sfs.ini
 
diff --git a/src/vfs/fish/helpers/Makefile.am b/src/vfs/fish/helpers/Makefile.am
index 3064b01..5680f35 100644
--- a/src/vfs/fish/helpers/Makefile.am
+++ b/src/vfs/fish/helpers/Makefile.am
@@ -1,4 +1,4 @@
-fishdir = $(libexecdir)/@PACKAGE@/fish
+fishdir = $(FISHHELPERSDIR)
 
 # Files to install and distribute other than fish scripts
 FISH_MISC  = README.fish
