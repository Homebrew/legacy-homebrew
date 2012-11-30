require 'formula'

class Fastbit < Formula
  homepage 'https://sdm.lbl.gov/fastbit/'
  url 'https://codeforge.lbl.gov/frs/download.php/400/fastbit-ibis1.3.4.tar.gz'
  sha1 'ba1f55942a684f49a75631116492968db17e11d3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "fastbit-config --version"
  end
end
