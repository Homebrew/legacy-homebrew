require 'formula'

class Mathgl < Formula
  url 'http://downloads.sourceforge.net/mathgl/mathgl-1.11.2.tar.gz'
  homepage 'http://mathgl.sourceforge.net'
  md5 'acd33e68911d9506f60d769dce23f95e'

  depends_on 'gsl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
