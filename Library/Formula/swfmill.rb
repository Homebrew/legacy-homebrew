require 'formula'

class Swfmill < Formula
  homepage 'http://swfmill.org'
  url 'http://swfmill.org/releases/swfmill-0.3.2.tar.gz'
  sha1 'e7ac1f267e4cbb8166acf6af78ddae914feed207'

  depends_on 'pkg-config' => :build
  depends_on :freetype
  depends_on :libpng

  def install
    system "./configure", "--prefix=#{prefix}"
    # Has trouble linking against zlib unless we add it here - @adamv
    system "make", "LIBS=-lz", "install"
  end
end
