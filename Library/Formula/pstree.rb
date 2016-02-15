# Note, the version of pstree used on Linux requires
# the /proc file system, which is not available on OS X.

class Pstree < Formula
  desc "Show ps output as a tree"
  homepage "http://www.thp.uni-duisburg.de/pstree/"
  url "ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.39.tar.gz"
  mirror "https://fossies.org/linux/misc/pstree-2.39.tar.gz"
  sha256 "7c9bc3b43ee6f93a9bc054eeff1e79d30a01cac13df810e2953e3fc24ad8479f"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "624458274db8e826c170121061ad25547c5a245788c8108bd2bf0af4a3678dea" => :el_capitan
    sha256 "127b605bf4b20cbddf63f875bd15f78ad5fc31eaebb57d9ce2051a3b856a8bd5" => :yosemite
    sha256 "2334d959beae2171fe10f6781a060eab40d57b841aa1905ead0b0936fb4145ef" => :mavericks
  end

  def install
    system "make", "pstree"
    bin.install "pstree"
    man1.install "pstree.1"
  end

  test do
    lines = shell_output("#{bin}/pstree #{Process.pid}").strip.split("\n")
    assert_match $0, lines[0]
    assert_match "#{bin}/pstree", lines[1]
  end
end
