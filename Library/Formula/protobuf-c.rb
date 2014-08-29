require "formula"

class ProtobufC < Formula
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.0.1/protobuf-c-1.0.1.tar.gz"
  sha1 "5928059292462aa6696c38857a3ca541a54f1b3f"

  bottle do
    sha1 "3e7b3432a5284e9308d0318357ff06ee960e5ed6" => :mavericks
    sha1 "c1dd644b5f4560a0e70b9bb9085dc50ef0bed98a" => :mountain_lion
    sha1 "6502775b0cd40d27334dfde490369cbfe7a9fa2a" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
