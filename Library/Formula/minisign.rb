class Minisign < Formula
  desc "A simple tool to sign files and verify signatures. Signatures are compatible with OpenBSD’s signify tool."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.4.tar.gz"
  version "0.4"
  sha256 "dc7695513e715654a51d07ad3e6b0083f9cb38b1a5bc9f16e1177d15af992dcc"

  # depends_on "cmake" => :build
  depends_on "libsodium"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    #system "false"
  end
end
