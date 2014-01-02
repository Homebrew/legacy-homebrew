require 'formula'

class Geany < Formula
  homepage 'http://geany.org/'
  url 'http://download.geany.org/geany-1.23.1.tar.gz'
  sha1 'b4813a897320b8158cb73fea0c4e2cead07adbc2'

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
