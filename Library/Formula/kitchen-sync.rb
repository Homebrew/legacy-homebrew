class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.44.tar.gz"
  sha256 "71a0c67b22e2d24da5b2c6faa9a90e5be916c13ad912f157bd6bc8a04764ee2e"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "2cbbf12595f166710c909c85b2b64190e57d81eea542f6eb99c3d73fb6122640" => :yosemite
    sha256 "b3ce6ae6fcc7aed040b371e06c9a06976a9005fa040903ba6d546ddb5ff2f776" => :mavericks
    sha256 "8c64ffe1621bc414a51209cf52cf39bae43ed9234c5c5f7eadb424923ee15f23" => :mountain_lion
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
