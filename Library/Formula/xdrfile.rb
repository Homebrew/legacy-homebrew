require 'formula'

class Xdrfile < Formula
  url 'ftp://ftp.gromacs.org/pub/contrib/xdrfile-1.1.1.tar.gz'
  homepage 'http://www.gromacs.org/'
  md5 '1ceb84765ec212a6f709faf559649023'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
