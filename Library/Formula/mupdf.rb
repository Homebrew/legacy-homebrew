require 'formula'

class Mupdf < Formula
  homepage 'http://mupdf.com'
  url 'https://mupdf.googlecode.com/files/mupdf-1.3-source.tar.gz'
  sha1 '082325aceb5565b07b82c2b6cc52a97533e03cf9'
  revision 1

  depends_on :macos => :snow_leopard
  depends_on :x11

  def install
    system "make", "install", "build=release", "prefix=#{prefix}"
  end
end
