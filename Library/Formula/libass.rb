require 'formula'

class Libass < Formula
  homepage 'http://code.google.com/p/libass/'
  url 'http://libass.googlecode.com/files/libass-0.10.1.tar.gz'
  sha1 '6537c572115cacb6011e314f9d4d37b1a7d0df8d'

  depends_on 'pkg-config' => :build
  depends_on :freetype
  depends_on 'fribidi'
  depends_on :fontconfig

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
