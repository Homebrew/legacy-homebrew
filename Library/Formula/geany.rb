require 'formula'

class Geany < Formula
  homepage 'http://geany.org/'
  url 'http://download.geany.org/geany-1.24.1.tar.gz'
  sha1 '2707b6bbcc4710e3dca990d26f66d679d82a2cc0'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
