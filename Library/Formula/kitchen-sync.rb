class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.51.tar.gz"
  sha256 "d0751354ae79f13058d40150f04c5a45c2b682af96617478265ecc4a9b4a4354"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "d69bde90eb02a150d162493be7a2c3956d6d76b3c6075c441e16f2f23c581aaf" => :el_capitan
    sha256 "9060d762e20e6ddd83acba864f8f9801cb4b3023a91790db3a1da4714a8fffd0" => :yosemite
    sha256 "62a9b845c4acf376e7c58fd596e57adbfcf88d93e7cd0972b3345517f37234f7" => :mavericks
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
