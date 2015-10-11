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
    revision 1
    sha256 "1384492af3d3ae0c57cd8d9b57ff40ebdd6b2d077a17e7a34796bb824c2211ef" => :el_capitan
    sha256 "981c4ac06c8c3740f84390a65736437cb94eb163c0e2f06cc15f7ef440257826" => :yosemite
    sha256 "8ddef0f2adb1ff02997d9f0eed6ed753cbbf9d594bfc5f25a3865ab08c653d6a" => :mavericks
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
