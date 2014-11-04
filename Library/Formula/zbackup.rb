require "formula"

class Zbackup < Formula
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.3.tar.gz"
  sha1 "e656944cc7bec5267f4b01055ea17b90e63c2d8c"

  bottle do
    cellar :any
    sha1 "cc138208a5b1670b745b78ff118fa1decb9f0e81" => :yosemite
    sha1 "81156fb3b1fbc40287afa03176c46f740cb01646" => :mavericks
    sha1 "b5384a251577f2b9d6465ac72db9fe35503f2aea" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup backup backups/test.bak"
  end
end
