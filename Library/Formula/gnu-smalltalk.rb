require 'formula'

class GnuSmalltalk < Formula
  homepage 'http://smalltalk.gnu.org/'
  url 'http://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.4.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.4.tar.xz'
  sha1 '75b7077a02abb2ec01c5975e22d6138b541db38e'

  head 'https://github.com/bonzini/smalltalk.git'

  option 'tests', 'Verify the build with make check (this may hang)'
  option 'tcltk', 'Build the Tcl/Tk module that requires X11'

  # Need newer versions on Snow Leopard
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on 'pkg-config' => :build
  depends_on 'xz'         => :build
  depends_on 'gawk'       => :build
  depends_on 'readline'   => :build
  depends_on 'libffi'     => :recommended
  depends_on 'libsigsegv' => :recommended
  depends_on 'glew'       => :optional
  depends_on :x11 if build.include? 'tcltk'

  fails_with :llvm do
    build 2334
    cause "Codegen problems with LLVM"
  end

  def patches
    # Builds GNU Smalltalk clean in 64-bit mode with SDL and Cairo support
    # by using autoconf version 2.61 and automake version 1.10. The testsuite
    # requires 2.63, however. So exclude the patch for that case. See also:
    # http://www.eighty-twenty.org/index.cgi/tech/smalltalk/building-gnu-smalltalk-20110926.html
    DATA unless build.include? 'tests'
  end

  def install
    ENV.m32 unless MacOS.prefer_64_bit?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gtk
      --with-readline=#{Formula.factory('readline').lib}
    ]
    unless build.include? 'tcltk'
      args << '--without-tcl' << '--without-tk' << '--without-x'
    end

    # disable generational gc in 32-bit
    args << "--disable-generational-gc" unless MacOS.prefer_64_bit?

    system 'autoreconf', '-ivf'
    system "./configure", *args
    system "make"
    system 'make', '-j1', 'check' if build.include? 'tests'
    system "make install"
  end
end

__END__
--- a/Makefile.am	2011-03-21 04:32:44.000000000 -0700
+++ b/Makefile.am	2012-10-14 14:52:13.000000000 -0700
@@ -16,7 +16,7 @@
 # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

 # Automake requirements
-AUTOMAKE_OPTIONS = gnu 1.11 dist-xz
+AUTOMAKE_OPTIONS = gnu 1.10
 ACLOCAL_AMFLAGS = -I build-aux
 DISTCHECK_CONFIGURE_FLAGS=--without-system-libltdl --without-system-libsigsegv --without-system-libffi

--- a/configure.ac	2011-03-21 04:32:44.000000000 -0700
+++ b/configure.ac	2012-10-14 14:53:34.000000000 -0700
@@ -6,7 +6,7 @@
 dnl Process this file with autoconf to produce a configure script.

 dnl 2.63 needed by testsuite, actually
-AC_PREREQ(2.63)
+AC_PREREQ(2.61)
 AC_INIT([GNU Smalltalk], 3.2.4, help-smalltalk@gnu.org, smalltalk,
         [http://smalltalk.gnu.org/])
 MAINTAINER="bonzini@gnu.org"
