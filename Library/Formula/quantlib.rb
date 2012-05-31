require 'formula'

class Quantlib < Formula
  url 'http://sourceforge.net/projects/quantlib/files/QuantLib/1.1/QuantLib-1.1.tar.gz'
  homepage 'http://quantlib.org/'
  md5 'bca1281b64677edab96cc97d2b1a6678'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
