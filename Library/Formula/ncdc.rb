require 'formula'

class Ncdc < Formula
  homepage 'http://dev.yorhel.nl/ncdc'
  url 'http://dev.yorhel.nl/download/ncdc-1.15.tar.gz'
  sha1 '2070d5e24201079445be15845a5f36cba874c0a5'

  depends_on 'glib'
  depends_on 'sqlite'
  depends_on 'gnutls'
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ncdc -v"
  end
end
