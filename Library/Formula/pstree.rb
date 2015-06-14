# Note, the version of pstree used on Linux requires
# the /proc file system, which is not available on OS X.

class Pstree < Formula
  desc "Show ps output as a tree"
  homepage "http://www.thp.uni-duisburg.de/pstree/"
  url "ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.39.tar.gz"
  mirror "https://fossies.org/linux/misc/pstree-2.39.tar.gz"
  sha256 "7c9bc3b43ee6f93a9bc054eeff1e79d30a01cac13df810e2953e3fc24ad8479f"

  def install
    system "make pstree"
    bin.install "pstree"
  end

  test do
    lines = `#{bin}/pstree #{Process.pid}`.strip.split("\n")
    assert lines[0].include?($0)
    assert lines[1].include?("#{bin}/pstree")
    assert_equal 0, $?.exitstatus
  end
end
