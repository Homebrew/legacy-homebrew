class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.2/poco-1.7.2-all.tar.gz"
  sha256 "926eaf5cb7c61ead0450b1cd9ec7a2c074a3e26620bffcb78e22ad3b2d9f0630"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "a63143c104d73bcc6d5895682f3924121d8f885f7b97c933652219e2b8e7edb4" => :el_capitan
    sha256 "1d9084a724fb5f93777a8400e4e9d376260ad59410bb8c43b354249a6dbfd169" => :yosemite
    sha256 "814bee36baa3286c2b6e22de23d3108693f5e8894e2ffff88e2ecefbdead5b8f" => :mavericks
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
