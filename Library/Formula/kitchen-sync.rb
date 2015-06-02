class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.38.tar.gz"
  sha256 "786bf30caca4e58347c0880dc1ca54685cd01d0834024c425029fb5466c96041"
  head "https://github.com/willbryant/kitchen_sync.git"

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
