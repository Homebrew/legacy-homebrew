class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.44.tar.gz"
  sha256 "71a0c67b22e2d24da5b2c6faa9a90e5be916c13ad912f157bd6bc8a04764ee2e"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    revision 1
    sha256 "befcbf5f5903fa90db560e530d7bdb295878e70fe9b4e434bf8ee39f36bcf249" => :yosemite
    sha256 "b0ba6ae728a6b1685dc2aa615616eefc19306ce6826eb82243ae5f1edbb11846" => :mavericks
    sha256 "540b909f42b32a3eaccb393ed4671f5ef0044b800f2c256c7f2437d70f35dcc8" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp" => (MacOS.version <= :mountain_lion ? "c++11" : [])

  depends_on :mysql => :recommended
  depends_on :postgresql => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    shell_output "#{bin}/ks 2>&1", 1
  end
end
