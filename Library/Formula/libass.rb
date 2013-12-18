require 'formula'

class Libass < Formula
  homepage 'http://code.google.com/p/libass/'
  url 'http://libass.googlecode.com/files/libass-0.10.2.tar.gz'
  sha1 'd50f9d242a26d5b84392608225f7fd03b1758af5'

  depends_on 'pkg-config' => :build
  depends_on :freetype
  depends_on 'fribidi'
  depends_on :fontconfig

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
