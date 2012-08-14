require 'formula'

# References:
# * http://smalltalk.gnu.org/wiki/building-gst-guides
#
# Note for version 3.2.2, we build 32-bit, which means that 64-bit
# optional dependencies will break the build. You may need
# to "brew unlink" these before installing GNU Smalltalk and
# "brew link" them afterwards:
# * gdbm

class GnuSmalltalk < Formula
  homepage 'http://smalltalk.gnu.org/'
  url 'http://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.2.tar.gz'
  sha1 'a985d69e4760420614c9dfe4d3605e47c5eb8faa'

  head 'https://github.com/bonzini/smalltalk.git'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libffi' if ARGV.build_head?
  depends_on 'libsigsegv' if ARGV.build_head?

  fails_with :llvm do
    build 2334
    cause "Codegen problems with LLVM"
  end

  def patches
    # Builds GNU Smalltalk clean in 64-bit mode with SDL and Cairo support
    # by using autoconf version 2.61 and automake version 1.10.

    # More information here:
    # http://www.eighty-twenty.org/index.cgi/tech/smalltalk/building-gnu-smalltalk-20110926.html

    DATA if ARGV.build_head?
  end

  def install
    # GNU Smalltalk thinks it needs GNU awk, but it works fine
    # with OS X awk, so let's trick configure.
    system "ln -s /usr/bin/awk #{buildpath}/gawk"
    ENV['AWK'] = "#{buildpath}/gawk"

    if ARGV.build_head?
      ENV.m32 unless MacOS.prefer_64_bit?

      system "autoreconf -fi"
    else
      # 64-bit version doesn't build in 3.2.2, so force 32 bits.
      ENV.m32

      if MacOS.prefer_64_bit? and Formula.factory('gdbm').installed?
        onoe "A 64-bit gdbm will cause linker errors"
        puts <<-EOS.undent
          GNU Smalltalk doesn't compile 64-bit clean on OS X, so having a
          64-bit gdbm installed will break linking you may want to do:
            $ brew unlink gdbm
            $ brew install gnu-smalltalk
            $ brew link gdbm
        EOS
      end

      ENV['FFI_CFLAGS'] = '-I/usr/include/ffi'
    end

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-readline=#{Formula.factory("readline").lib}"]

    # disable generational gc to build HEAD in 32-bit
    args << "--disable-generational-gc" if ARGV.build_head? and not MacOS.prefer_64_bit?

    system "./configure", *args
    system "make"
    ENV.deparallelize # Parallel install doesn't work
    system "make install"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index 732a72c..121e90a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,7 @@
 # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

 # Automake requirements
-AUTOMAKE_OPTIONS = gnu 1.11 dist-xz
+AUTOMAKE_OPTIONS = gnu 1.10
 ACLOCAL_AMFLAGS = -I build-aux

 PACKAGE=smalltalk
diff --git a/configure.ac b/configure.ac
index e45cda3..6a66275 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ dnl with this software.
 dnl Process this file with autoconf to produce a configure script.

 dnl 2.63 needed by testsuite, actually
-AC_PREREQ(2.63)
+AC_PREREQ(2.61)
 AC_INIT([GNU Smalltalk], 3.2.90, help-smalltalk@gnu.org, smalltalk,
         [http://smalltalk.gnu.org/])
 MAINTAINER="bonzini@gnu.org"
