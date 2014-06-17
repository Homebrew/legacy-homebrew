require 'formula'

class Mupdf < Formula
  homepage 'http://mupdf.com'
  url 'http://mupdf.com/downloads/mupdf-1.5-source.tar.gz'
  sha1 '628470ed20f9a03c81e90cd5585a31c0fab386ef'

  depends_on :macos => :snow_leopard
  depends_on :x11

  def install
    system "make", "install", "build=release", "prefix=#{prefix}"
  end
end
