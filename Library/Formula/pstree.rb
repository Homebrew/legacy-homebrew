# Note, the version of pstree used on Linux requires
# the /proc file system, which is not available on OS X.

class Pstree < Formula
  desc "Show ps output as a tree"
  homepage "http://www.thp.uni-duisburg.de/pstree/"
  url "ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.39.tar.gz"
  mirror "https://fossies.org/linux/misc/pstree-2.39.tar.gz"
  sha256 "7c9bc3b43ee6f93a9bc054eeff1e79d30a01cac13df810e2953e3fc24ad8479f"

  bottle do
    cellar :any
    sha256 "e752523adfbaf41841223daecda76a7ba06bff2b16991a1a48ec578089585e8c" => :yosemite
    sha256 "96bdb89f6795d6299d4b0436726a9f99e986435e1513f4c720c8ac88d1485f06" => :mavericks
    sha256 "5a179b362495b0ab4af831307f536a97c697db6d3498eca84dc7c2437ea60058" => :mountain_lion
  end

  def install
    system "make", "pstree"
    bin.install "pstree"
  end

  test do
    lines = `#{bin}/pstree #{Process.pid}`.strip.split("\n")
    assert lines[0].include?($0)
    assert lines[1].include?("#{bin}/pstree")
    assert_equal 0, $?.exitstatus
  end
end
