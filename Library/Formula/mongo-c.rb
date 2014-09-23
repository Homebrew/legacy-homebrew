require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.0.0/mongo-c-driver-1.0.0.tar.gz"
  sha1 "d9a91374b7273f09da859822e61f3caa09756f23"

  bottle do
    cellar :any
    sha1 "c9175b6abffee51eddca3b20d6e08a723056d3f5" => :mavericks
    sha1 "c62ace3a7e2948b3c2a942f5b4bf25085cedbf8e" => :mountain_lion
    sha1 "ae9bbb89274eb9c46b5073970238c2ad76d46c5d" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libbson"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
