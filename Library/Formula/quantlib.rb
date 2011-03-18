require 'formula'

class Quantlib < Formula
  url 'http://sourceforge.net/projects/quantlib/files/QuantLib/1.0.1/QuantLib-1.0.1.tar.gz'
  homepage 'http://quantlib.org/'
  md5 'e879dc02de33e1f4b90666346a90a280'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
