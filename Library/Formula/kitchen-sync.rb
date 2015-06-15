class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.40.tar.gz"
  sha256 "2a595cf3b562a2d9d02fcb8fbc5bd8908b2cbadcbf51d817fe9562ae85b77061"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "503df2ae1c658d0ceb260d06bc591b6267a1839e09c05f14ab3c1ce3841f54be" => :yosemite
    sha256 "503c33bdee14bce9a97f8cf4070bf4427a3c251db4d588ffcdf4591021ef024e" => :mavericks
    sha256 "d8cc48756b8839c9acfb79f37acf312ee33731c47a505e71b69a9fb12148d22d" => :mountain_lion
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
