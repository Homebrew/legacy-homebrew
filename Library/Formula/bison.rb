require 'formula'

class Bison < Formula
  url 'ftp://ftpmirror.gnu.org/gnu/bison/bison-2.5.tar.gz'
  homepage 'http://www.gnu.org/software/bison/manual/'
  md5 '687e1dcd29452789d34eaeea4c25abe4'
  version '2.5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "bison --version"
  end
end
