class Treecc < Formula
  desc "Aspect-oriented approach to writing compilers"
  homepage "http://gnu.org/software/dotgnu/treecc/treecc.html"
  url "http://download.savannah.gnu.org/releases/dotgnu-pnet/treecc-0.3.10.tar.gz"
  sha256 "5e9d20a6938e0c6fedfed0cabc7e9e984024e4881b748d076e8c75f1aeb6efe7"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "treecc"
  end

  test do
    system "#{bin}/treecc", "-v"
  end
end
