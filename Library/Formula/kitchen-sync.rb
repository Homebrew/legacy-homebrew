class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.52.tar.gz"
  sha256 "a15bc2a8cc6e245d19a86e9427494f0f8d49d0d791f37147a3f17db9d20284f5"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "12946e567a8791dd7db482c97d79a4b2ee5b9ae27ba22823069af7a2e879c9fd" => :el_capitan
    sha256 "a3f3ed66943977a00d65975cd67025d0154d2eba2ae5653e23934e3bdab92059" => :yosemite
    sha256 "47ec104c18a7ac81499e493f3ae494b466eb89e07cbac56f29a71ff08794caa5" => :mavericks
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
