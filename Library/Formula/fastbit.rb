require 'formula'

class Fastbit < Formula
  homepage 'https://sdm.lbl.gov/fastbit/'
  url 'https://codeforge.lbl.gov/frs/download.php/401/fastbit-ibis1.3.5.tar.gz'
  sha1 '3a01de4474b88cd042cafea41d73f3ecf87be747'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fastbit-config", "--version"
  end
end
