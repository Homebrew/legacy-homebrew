require 'formula'

class Renameutils < Formula
  url 'http://nongnu.uib.no/renameutils/renameutils-0.10.0.tar.gz'
  homepage 'http://www.nongnu.org/renameutils/'
  md5 '77f2bb9a18bb25c7cc3c23b64f2d394b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end
end
