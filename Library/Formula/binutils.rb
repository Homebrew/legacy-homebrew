require 'formula'

class Binutils < Formula
  url 'http://ftp.gnu.org/gnu/binutils/binutils-2.21.tar.gz'
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  md5 'f11e10f312a58d82f14bf571dd9ff91c'

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
