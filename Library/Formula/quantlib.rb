require 'formula'

class Quantlib < Formula
  homepage 'http://quantlib.org/'
  url 'http://sourceforge.net/projects/quantlib/files/QuantLib/1.2.1/QuantLib-1.2.1.tar.gz'
  sha1 '2a9faf539c7452f2f6c2b8d593677cd133659742'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
