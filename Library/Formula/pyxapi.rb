require 'formula'

class Pyxapi < Formula
  url 'http://www.pps.jussieu.fr/~ylg/PyXAPI/PyXAPI-0.1.tar.gz'
  homepage 'http://www.pps.jussieu.fr/~ylg/PyXAPI'
  md5 'b91e9f1492fa2db7e2f0c98e568de3eb'

  depends_on 'Python'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make test"
    system "make install"
  end
end
