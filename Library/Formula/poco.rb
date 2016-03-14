class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.1/poco-1.7.1-all.tar.gz"
  sha256 "337d82fdd648e50e5a25fa58ca9f66d5e7a381548cae412d13097a85498c5915"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "50e6824d1d27a1520fe4eca9fcf3deb77d3c105831d64573623bc0af94b24177" => :el_capitan
    sha256 "c7e514afcf691fdb26c506dfe4ed5ee9fabde66670e204dbf1a16d0087f3dc3a" => :yosemite
    sha256 "3577b7a4f6a4a6f8be3b7b5a8aa156e5ee71d8c72bbd285eeaa09768d7f10a03" => :mavericks
  end

  option :cxx11
  option :universal
  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "macbuild" do
      system "cmake", buildpath, *args
      system "make", "install"
    end
  end
end
