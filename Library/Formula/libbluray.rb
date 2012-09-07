require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.2.2/libbluray-0.2.2.tar.bz2'
  sha1 'b0ce210736d012e4a5f155ec4ead3fc58abe143a'

  head 'git://git.videolan.org/libbluray.git'

  depends_on 'pkg-config' => :build
  depends_on :automake
  depends_on :libtool

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
