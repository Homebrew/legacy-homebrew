class Yajl < Formula
  desc "Yet Another JSON Library"
  homepage "https://lloyd.github.io/yajl/"
  url "https://github.com/lloyd/yajl/archive/2.1.0.tar.gz"
  sha256 "3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a"

  bottle do
    cellar :any
    revision 4
    sha256 "5cfd83bfdbd7c92402f1cecc6b66788e6db0c195880a40263365d8130e47db2f" => :el_capitan
    sha256 "600fec6352ac23a66795cce22cb0a555df43eb464c87693299cb4fc2a1307833" => :yosemite
    sha256 "d44363e381f2f353387374167520ed166f3c0c756887dab6e015961bd9ba5ff3" => :mavericks
    sha256 "d35963d9d40c22e83a878a98a470f88405abf13efa61c7a3a999d7d79724b525" => :mountain_lion
  end

  # Configure uses cmake internally
  depends_on "cmake" => :build

  def install
    ENV.deparallelize

    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (include/"yajl").install Dir["src/api/*.h"]
  end

  test do
    output = pipe_output("#{bin}/json_verify", "[0,1,2,3]").strip
    assert_equal "JSON is valid", output
  end
end
