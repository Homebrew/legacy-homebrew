class Poco < Formula
  desc "POCO C++ Libraries"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.6.1/poco-1.6.1-all.tar.gz"
  sha256 "88c88ff0916228d3a011b86c486033dab75e62a27429b5d35736d43527cf5b44"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha1 "32c3d4f754f5fd1b01fa2455a070f5057582a1a4" => :yosemite
    sha1 "1d844a6baf5ffa6c19697623aceb0d0035e4be38" => :mavericks
    sha1 "4f039170113a69a61657d35a2a0206743bd7f416" => :mountain_lion
  end

  option :cxx11
  option :universal

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

    if build.stable?
      # Fix Foundation library version (already fixed upstream).
      inreplace "Foundation/CMakeLists.txt", "VERSION ${PROJECT_VERSION}", "VERSION ${SHARED_LIBRARY_VERSION}"
    end

    mkdir "macbuild" do
      system "cmake", buildpath, *args
      system "make", "install"
    end
  end
end
