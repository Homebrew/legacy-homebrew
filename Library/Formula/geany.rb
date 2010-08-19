require 'formula'

class Geany <Formula
  url 'http://download.geany.org/geany-0.19.tar.gz'
  homepage 'http://www.geany.org/Main/HomePage'
  md5 '727cec2936846850bb088b476faad5f2'

  depends_on 'pkg-config'
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
