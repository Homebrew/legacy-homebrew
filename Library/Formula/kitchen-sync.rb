class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.51.tar.gz"
  sha256 "d0751354ae79f13058d40150f04c5a45c2b682af96617478265ecc4a9b4a4354"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "ee4812fb056cc8dcb7e72c90dcae52563b6d0747d8b6378b7181e7fa80359e05" => :el_capitan
    sha256 "121915ac3557892378929b298d63382c809ac795eb0226e033fcf62e80774657" => :yosemite
    sha256 "96a0f85264b9d1ea64af7342f955055e5c108e08b2e07b0fa73c60feff6a9825" => :mavericks
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
