require 'formula'

class Treecc < Formula
  homepage 'http://gnu.org/software/dotgnu/treecc/treecc.html'
  url 'http://download.savannah.gnu.org/releases/dotgnu-pnet/treecc-0.3.10.tar.gz'
  sha1 'f905cb535559b0e2d04fa86da14de240f5b1e44f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "treecc"
  end

  test do
    system "#{bin}/treecc", "-v"
  end
end
