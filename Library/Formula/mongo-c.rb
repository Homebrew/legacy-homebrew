require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/0.98.2/mongo-c-driver-0.98.2.tar.gz"
  sha1 "6eb74406412a152029a043cd9a0043d0e4d9107b"

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
