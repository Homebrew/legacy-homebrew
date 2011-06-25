require 'formula'

class Geany < Formula
  homepage 'http://geany.org/'
  url 'http://download.geany.org/geany-0.20.tar.gz'
  sha256 '8d8ec9411c58c706befcca00435f4ec7af2f60a057e9fac232246f4893bf4050'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gtk+'

  def install
    intltool = Formula.factory('intltool')
    ENV.append "PATH", intltool.bin, ":"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
