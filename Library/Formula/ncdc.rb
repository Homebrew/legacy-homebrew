require 'formula'

class Ncdc < Formula
  homepage 'http://dev.yorhel.nl/ncdc'
  url 'http://dev.yorhel.nl/download/ncdc-1.18.1.tar.gz'
  sha1 '184dce59b5b51563f869a43d81971a1537cdc438'

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
