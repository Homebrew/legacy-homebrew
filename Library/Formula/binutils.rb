require 'formula'

class Binutils < Formula
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.21.1a.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  md5 'bde820eac53fa3a8d8696667418557ad'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--enable-interwork",
            "--enable-multilib",
            "--enable-targets=x86_64-elf",
            "--enable-targets=arm-none-eabi"]
    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args
    system "make"
    system "make install"
  end
end
