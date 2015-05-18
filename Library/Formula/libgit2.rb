class Libgit2 < Formula
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.22.1.tar.gz"
  sha256 "c7f1bf99ed8aeba65a485489869e2a50f022f3cd847df85e192fc99fdd6c8b5e"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "2a82725022d06bb36807274f003797938f9b2b0544270b6ba04c29acfdfbd0de" => :yosemite
    sha256 "e8fa9e5bda12a415c8da8ca0d38ae22a5e59794159cc3d0f5a5527d51d494029" => :mavericks
    sha256 "4b050924591f0ef948c713c767e9f50504648e191bce4439ebe952c52b56ef8a" => :mountain_lion
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
