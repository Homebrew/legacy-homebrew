require 'formula'

class Binutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz'
  sha1 '1b2bc33003f4997d38fadaa276c1f0321329ec56'

  def patches
    # [PATCH] libiberty: fix --enable-install-libiberty flag
    'http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/patchsets/binutils/2.24/20_all_libiberty-install.patch'
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-install-libiberty",
                          "--enable-targets=all"
    system "make"
    system "make install"
  end
end
