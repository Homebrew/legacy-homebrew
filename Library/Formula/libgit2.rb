class Libgit2 < Formula
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.22.0.tar.gz"
  sha1 "a37dc29511422eec9828e129ad057e77ca962c5e"
  head "https://github.com/libgit2/libgit2.git"
  revision 1

  bottle do
    cellar :any
    sha256 "722c0d7fee0826e2534f43d71bd7f3df20b09802db53bbcdf1f3b72c073b888d" => :yosemite
    sha256 "4ebcae368e74ebe396032744b5790e2af3ce37ec3035a852ba1ed08d9559fff5" => :mavericks
    sha256 "d0a6034bc1dcabd209ca79727320cc64fe13f9b336ae51cc3cb8f9d62fd39d99" => :mountain_lion
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
