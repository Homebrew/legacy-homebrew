require 'formula'

class Guile < Formula
  homepage 'http://www.gnu.org/software/guile/'
  url 'http://ftpmirror.gnu.org/guile/guile-2.0.9.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/guile/guile-2.0.9.tar.gz'
  sha1 'fc5d770e8b1d364b2f222a8f8c96ccf740b2956f'

  head do
    url 'git://git.sv.gnu.org/guile.git'

    depends_on 'automake' => :build
    depends_on 'gettext' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'libffi'
  depends_on 'libunistring'
  depends_on 'bdw-gc'
  depends_on 'gmp'

  # GNU Readline is required; libedit won't work.
  depends_on 'readline'

  fails_with :llvm do
    build 2336
    cause "Segfaults during compilation"
  end

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  # Only for 2.0.9: Fix shebang shell in build-aux/install-sh.
  # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=14201#19
  def patches; DATA; end

  def install
    system './autogen.sh' if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula.factory('readline').prefix}"
    system "make install"

    # A really messed up workaround required on OS X --mkhl
    lib.cd { Dir["*.dylib"].each {|p| ln_sf p, File.basename(p, ".dylib")+".so" }}
  end
end

__END__
--- guile-2.0.9.orig/build-aux/install-sh  2013-01-28 12:35:24.000000000 -0800
+++ guile-2.0.9/build-aux/install-sh	2013-04-21 08:41:10.000000000 -0700
@@ -1,4 +1,4 @@
-#!/nix/store/ryk1ywzz31kp4biclxq3yq6hpjycalyy-bash-4.2/bin/sh
+#!/bin/sh
 # install - install a program, script, or datafile

 scriptversion=2011-11-20.07; # UTC
