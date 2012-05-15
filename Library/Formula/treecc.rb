require 'formula'

class Treecc < Formula
  url 'http://download.savannah.gnu.org/releases/dotgnu-pnet/treecc-0.3.10.tar.gz'
  homepage 'http://gnu.org/software/dotgnu/treecc/treecc.html'
  md5 'def09f2132f87d6a38a0718e2f14ee61'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "treecc"
  end

  def test
    system "#{bin}/treecc", "-v"
  end
end
