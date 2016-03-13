class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.0/poco-1.7.0-all.tar.gz"
  sha256 "7aebee1b998c2d5ceac4328dfd98fcd4f69028d3efd37bc1915112650ecd5abc"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "33df81188d98b0fcf1d15a6e13f84d3c4e2fcf5b1b96bb7c7f4f5e02366c93be" => :el_capitan
    sha256 "c5230b22ed0d24df4b5bdf6ca23dd96af5e68e5afe380a457ede2e3bf9d9ba3a" => :yosemite
    sha256 "bcf911a8a650595792d103e12364e3efc3b283d4fcc22caf7afaba5014786dd0" => :mavericks
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
