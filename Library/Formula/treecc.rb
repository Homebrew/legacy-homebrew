class Treecc < Formula
  desc "Aspect-oriented approach to writing compilers"
  homepage "https://gnu.org/software/dotgnu/treecc/treecc.html"
  url "http://download.savannah.gnu.org/releases/dotgnu-pnet/treecc-0.3.10.tar.gz"
  sha256 "5e9d20a6938e0c6fedfed0cabc7e9e984024e4881b748d076e8c75f1aeb6efe7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e74d23594113e594ad8021fe55b0f0f863fcd4b01140c3fd8b1a5f2bb6c8ad74" => :el_capitan
    sha256 "595dada9ecb2cef6d3e225e99a98997968d15f8009038511c464b6499cbcd872" => :yosemite
    sha256 "9f9a9e6a66c9e0a60888ad2af502070683637b5cd19dec6e080211a45c3313e6" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "treecc"
  end

  test do
    system "#{bin}/treecc", "-v"
  end
end
