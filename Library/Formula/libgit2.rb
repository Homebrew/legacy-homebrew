class Libgit2 < Formula
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.22.0.tar.gz"
  sha1 "a37dc29511422eec9828e129ad057e77ca962c5e"

  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha1 "f38b591523f02a8d3310ec203f1ab7d2c6d825e4" => :yosemite
    sha1 "ecfdcf794a06e2e501c2c95ca72cdc0f0a97c3ba" => :mavericks
    sha1 "0daa906f4cf15f9e9de9637c41c0e600aae36c4b" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libssh2" => :optional
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
