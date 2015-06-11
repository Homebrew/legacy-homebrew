class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.39.tar.gz"
  sha256 "f3a6e1b9ef66ff3436f4f2d6724d1b46a28c9d8c22509aeac5e6cbbcfe1e8201"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "3e51f0cdeefc74a5d3c87f9dd701c07adff75323ffd90a15424f21a3666d2ea0" => :yosemite
    sha256 "da57b940d500ded730b4d9defaa197dab1c2e5e59b14cab5209243b21c7ff9ac" => :mavericks
    sha256 "c7fd76c7ef6eef65ef0dbc69bc3063accf1f0262ebce4a5b8eb8fdc3f3515cb8" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on :mysql => :recommended
  depends_on :postgresql => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert File.exist?("#{bin}/ks")
    assert File.exist?("#{bin}/ks_mysql") if build.with? "mysql"
    assert File.exist?("#{bin}/ks_postgresql") if build.with? "postgresql"
  end
end
