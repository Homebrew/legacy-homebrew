require 'formula'

class Binutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.23.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.23.1.tar.gz'
  sha1 '2ce79f7800c05934e10f17455fc221be5e2527fa'

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
                          "--enable-targets=x86_64-elf,arm-none-eabi,m32r"
    system "make"
    system "make install"
  end
end
