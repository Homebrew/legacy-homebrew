class Minisign < Formula
  desc "Simply sign files and verify signatures. Compatible with signify in OpenBSD."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.4.tar.gz"
  sha256 "dc7695513e715654a51d07ad3e6b0083f9cb38b1a5bc9f16e1177d15af992dcc"

  depends_on "libsodium"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "minisign", "-v"
  end
end
