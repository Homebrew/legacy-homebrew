class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.44.tar.gz"
  sha256 "71a0c67b22e2d24da5b2c6faa9a90e5be916c13ad912f157bd6bc8a04764ee2e"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "87baca397a75557cfc5b26d7cea5509fd8573556bd34fa7d694ed5489e8eff8f" => :yosemite
    sha256 "9cd7a04c50df5367e63e4b00a18e941148fc2752d9e6d5f1c908933c17f16e04" => :mavericks
    sha256 "6af2c2e5747318f0c26fbf636d4e35c22d87a9953d7b69b7dd38e7bdeeca41c7" => :mountain_lion
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
