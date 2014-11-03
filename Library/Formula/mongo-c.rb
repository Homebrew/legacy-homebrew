require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.0.2/mongo-c-driver-1.0.2.tar.gz"
  sha1 "baa425d64dddf5f8267beb0cef509df5b80e5abb"

  bottle do
    cellar :any
    sha1 "d72b1c9554309ae5e3cfb1789d80f1e317f38d2d" => :yosemite
    sha1 "aeb42a0cc056fd23a3122fcbcab211251fe4f8f1" => :mavericks
    sha1 "d3ba4bf24c5a3fc195609ccd70cc65fc85d095dc" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libbson"
  depends_on "openssl"

  def install
    # --enable-sasl=no: https://jira.mongodb.org/browse/CDRIVER-447
    system "./configure", "--prefix=#{prefix}", "--enable-sasl=no"
    system "make", "install"
  end
end
