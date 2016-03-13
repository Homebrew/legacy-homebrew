class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.0/poco-1.7.0-all.tar.gz"
  sha256 "7aebee1b998c2d5ceac4328dfd98fcd4f69028d3efd37bc1915112650ecd5abc"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "c665c221f8270aca6730b71f890d6a90f056beb5147984607b8d5d8f3c27a0c6" => :el_capitan
    sha256 "b827dd402c26ba319a0041b2d5fe1b0a04384b44dd4560eb9647c292809e97de" => :yosemite
    sha256 "9c8fa247886f2e570298ff0ab9bde42926c3b9cf66eab7643a4799333fe07d55" => :mavericks
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
