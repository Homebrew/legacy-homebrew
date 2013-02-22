require 'formula'

class Ncdc < Formula
  homepage 'http://dev.yorhel.nl/ncdc'
  url 'http://dev.yorhel.nl/download/ncdc-1.14.tar.gz'
  sha1 'ff2ae3107097ce4cd03862841421f157198217ea'

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
