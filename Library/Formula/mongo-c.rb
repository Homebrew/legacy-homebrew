require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/0.98.0/mongo-c-driver-0.98.0.tar.gz"
  sha1 "7265e5f7865687e2e1dd59a106e5170534dfa3e1"

  bottle do
    cellar :any
    sha1 "2e4bb593b0a568a6d390f5eae5d56457bee739e8" => :mavericks
    sha1 "e3b7459776bfde3a4d88816cf14ac636f66ab3ff" => :mountain_lion
    sha1 "289d8fb5e3dbec51072b8903faaf08a92f165420" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libbson"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
