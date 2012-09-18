require 'formula'

class Quantlib < Formula
  homepage 'http://quantlib.org/'
  url 'http://sourceforge.net/projects/quantlib/files/QuantLib/1.2/QuantLib-1.2.tar.gz'
  sha1 'c53093adca31e598dc93385314d47f40c365e4b6'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
