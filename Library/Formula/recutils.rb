require 'formula'

class Recutils < Formula
  homepage 'http://www.gnu.org/software/recutils/'
  url 'http://ftpmirror.gnu.org/recutils/recutils-1.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/recutils/recutils-1.5.tar.gz'
  sha1 '36fca9624c4bd70ad20ba38c9c68350745fe4753'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
