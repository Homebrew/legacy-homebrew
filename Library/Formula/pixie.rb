require 'formula'

class Pixie < Formula
  url 'http://downloads.sourceforge.net/project/pixie/pixie/Pixie%202.2.6/Pixie-src-2.2.6.tgz'
  homepage 'http://www.renderpixie.com/'
  md5 'e2063e35d88c25c4b22b954af31ad87d'

  depends_on 'libtiff'
  depends_on 'fltk'
  depends_on 'openexr'

  def install
    openexr = Formula.factory('openexr')
    ilmbase = Formula.factory('ilmbase')

    ENV.x11 # For libpng
    ENV.append "CPPFLAGS", "-I#{openexr.include}/OpenEXR -I#{ilmbase.include}/OpenEXR"
    ENV.append "LDFLAGS",  "-L#{openexr.lib} -L#{ilmbase.lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openexr-prefix=#{openexr.prefix}"
    system "make install"
  end

  def test
    system "#{bin}/rndr", "-v"
  end
end
