require 'formula'

class Dieharder < Formula
  homepage 'http://www.phy.duke.edu/~rgb/General/dieharder.php'
  url 'http://www.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz'
  sha1 '506b1380c780f90372d9d4adcb5cfcc96234f2a8'

  depends_on 'gsl'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-shared"
    system "make", "install"
  end

  test do
    system "#{bin}/dieharder", "-a", "-g", "501"
  end
end
