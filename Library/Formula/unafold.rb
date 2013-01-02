require 'formula'

class Unafold < Formula
  homepage 'http://mfold.rna.albany.edu/'
  url 'http://mfold.rna.albany.edu/cgi-bin/UNAFold-download.cgi?unafold-3.8.tar.gz'
  sha1 'b4f0296af9809ecb9f067f5adf17249315a50b7d'

  depends_on 'gd'
  depends_on 'gnuplot'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
