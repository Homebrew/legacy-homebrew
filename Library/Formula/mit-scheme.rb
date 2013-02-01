require 'formula'

class MitScheme < Formula
  homepage 'http://www.gnu.org/software/mit-scheme/'
  url 'http://ftpmirror.gnu.org/mit-scheme/stable.pkg/9.1.1/mit-scheme-c-9.1.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.1.1/mit-scheme-c-9.1.1.tar.gz'
  sha1 '8f175a40061bdfc0248535e198cc7f5b5a0dce32'

  depends_on :x11 if MacOS::X11.installed?

  def patches
    # fix installation issue with OS X 10.7 and Xcode in /Applications
    # http://savannah.gnu.org/patch/?7775
    DATA
  end

  def install
    # The build breaks __HORRIBLY__ with parallel make -- one target will erase something
    # before another target gets it, so it's easier to change the environment than to
    # change_make_var, because there are Makefiles littered everywhere
    ENV.j1

    # Liarc builds must launch within the src dir, not using the top-level Makefile
    cd "src"

    # Take care of some hard-coded paths
    inreplace %w(6001/edextra.scm 6001/floppy.scm compiler/etc/disload.scm configure
    edwin/techinfo.scm edwin/unix.scm lib/include/configure lib/include/option.c
    swat/c/tk3.2-custom/Makefile swat/c/tk3.2-custom/tcl/Makefile swat/scheme/other/btest.scm) do |s|
      s.gsub! "/usr/local", prefix
    end

    # The configure script will add '-isysroot' to CPPFLAGS, so it didn't check .h here
    # by default even Homebrew is installed in /usr/local. This breaks things when gdbm
    # or other optional dependencies was installed using Homebrew
    ENV.prepend 'CPPFLAGS', "-I#{HOMEBREW_PREFIX}/include"

    system "etc/make-liarc.sh", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/src/configure b/src/configure
index 23187c9..4485b64 100755
--- a/src/configure
+++ b/src/configure
@@ -6257,7 +6257,10 @@ echo "$as_me: error: Unable to determine MacOSX version" >&2;}
     else
 	SDK=MacOSX${MACOSX}
     fi
+	MACOSX_SYSROOT=$(xcode-select --print-path)/Platforms/MacOSX.platform/Developer/SDKs/${SDK}.sdk
+	if test ! -d "${MACOSX_SYSROOT}"; then
     MACOSX_SYSROOT=/Developer/SDKs/${SDK}.sdk
+	fi
     if test ! -d "${MACOSX_SYSROOT}"; then
 	{ { echo "$as_me:$LINENO: error: No MacOSX SDK for version: ${MACOSX}" >&5
 echo "$as_me: error: No MacOSX SDK for version: ${MACOSX}" >&2;}

diff --git a/src/lib/include/configure b/src/lib/include/configure
index d4c7717..49be0a2 100755
--- a/src/lib/include/configure
+++ b/src/lib/include/configure
@@ -5311,7 +5311,10 @@ echo "$as_me: error: Unable to determine MacOSX version" >&2;}
     else
 	SDK=MacOSX${MACOSX}
     fi
+	MACOSX_SYSROOT=$(xcode-select --print-path)/Platforms/MacOSX.platform/Developer/SDKs/${SDK}.sdk
+	if test ! -d "${MACOSX_SYSROOT}"; then
     MACOSX_SYSROOT=/Developer/SDKs/${SDK}.sdk
+	fi
     if test ! -d "${MACOSX_SYSROOT}"; then
 	{ { echo "$as_me:$LINENO: error: No MacOSX SDK for version: ${MACOSX}" >&5
 echo "$as_me: error: No MacOSX SDK for version: ${MACOSX}" >&2;}
