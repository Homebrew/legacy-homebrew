require 'formula'

class GnuIndent < Formula
  homepage 'http://www.gnu.org/software/indent/'
  url 'http://ftpmirror.gnu.org/indent/indent-2.2.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/indent/indent-2.2.10.tar.gz'
  sha1 '20fa8a7a4af6670c3254c8b87020291c3db37ed1'

  depends_on 'gettext'

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "touch man/malloc.h"
    system "make"
    system "make install"
  end
end
