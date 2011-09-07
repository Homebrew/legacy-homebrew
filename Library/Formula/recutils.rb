require 'formula'

class Recutils < Formula
  url 'http://ftp.gnu.org/gnu/recutils/recutils-1.3.tar.gz'
  homepage 'http://www.gnu.org/software/recutils/'
  md5 '243d46f191cbbf2be3fd72a86234cd1c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
