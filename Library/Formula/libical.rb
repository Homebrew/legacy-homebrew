class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz"
  sha256 "089ce3c42d97fbd7a5d4b3c70adbdd82115dd306349c1f5c46a8fb3f8c949592"

  bottle do
    sha256 "eaef148f778ac575b2e1c3223cd26c8865d3ae86e274b1cab7bcf9b575086c38" => :yosemite
    sha256 "51288631d0f0656fdbe6d30eb333699e0f1c48a0b1defe72a9a7a3eeb0571a92" => :mavericks
    sha256 "014c0160a5bc9030409e6459799e4b9ae3474ea86d4ca1557b9a3d5d89e31232" => :mountain_lion
  end

  depends_on "cmake" => :build

  option :universal

  def install
    args = std_cmake_args
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", "-DSHARED_ONLY=true", *args
      system "make", "install"
    end
  end
end
