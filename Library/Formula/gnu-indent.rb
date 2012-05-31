require 'formula'

class GnuIndent < Formula
  url 'http://ftpmirror.gnu.org/indent/indent-2.2.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/indent/indent-2.2.10.tar.gz'
  homepage 'http://www.gnu.org/software/indent/'
  md5 'be35ea62705733859fbf8caf816d8959'

  depends_on "gettext"

  def options
    [['--default-names', "Do not prepend 'g' to the binary (will override system indent)"]]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args
    system "touch man/malloc.h"
    system "make"
    system "make install"
  end
end
