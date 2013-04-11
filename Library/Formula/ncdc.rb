require 'formula'

class Ncdc < Formula
  homepage 'http://dev.yorhel.nl/ncdc'
  url 'http://dev.yorhel.nl/download/ncdc-1.16.1.tar.gz'
  sha1 '3bdbf8c58a95eab2dc318bd853be991343f88fe9'

  depends_on 'glib'
  depends_on 'sqlite'
  depends_on 'gnutls'
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
