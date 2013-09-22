require 'formula'

class Quantlib < Formula
  homepage 'http://quantlib.org/'
  url 'http://downloads.sourceforge.net/project/quantlib/QuantLib/1.3/QuantLib-1.3.tar.gz'
  sha1 '6f212d62c300a9ef74cdbaec6c50a2f4a7f6a0b0'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
