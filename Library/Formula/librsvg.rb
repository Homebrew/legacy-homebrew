require 'formula'

class Librsvg < Formula
  homepage 'http://librsvg.sourceforge.net/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.34/librsvg-2.34.1.tar.bz2'
  sha256 '9f98ab27c4ae04a7c3a37277aeb581feb8035a8b1e1937b06e27423a176a0a73'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libcroco'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-tools=yes",
                          "--enable-pixbuf-loader=yes"
    system "make install"
  end
end
