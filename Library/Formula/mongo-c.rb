require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.0.0/mongo-c-driver-1.0.0.tar.gz"
  sha1 "d9a91374b7273f09da859822e61f3caa09756f23"

  bottle do
    cellar :any
    sha1 "836b7d4c633a4dacfaec96fc2bf8ad6439d5f34d" => :mavericks
    sha1 "495ea6b8af268e968c547f6da30a49ea37646ab9" => :mountain_lion
    sha1 "cb260593e2b06151fc0d3f09e1f1a4c2aa2d5390" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libbson"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
