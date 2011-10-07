require 'formula'

class Libsmi < Formula
  url 'ftp://ftp.ibr.cs.tu-bs.de/pub/local/libsmi/libsmi-0.4.8.tar.gz'
  homepage 'http://www.ibr.cs.tu-bs.de/projects/libsmi/'
  md5 '760b6b1070738158708649ed2c63425e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
