require "formula"

class MongoC < Formula
  homepage "http://docs.mongodb.org/ecosystem/drivers/c/"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/0.98.0/mongo-c-driver-0.98.0.tar.gz"
  sha1 "7265e5f7865687e2e1dd59a106e5170534dfa3e1"

  bottle do
    cellar :any
    sha1 "4f02db86827e0f95979f027c2bb44c3fd19ae463" => :mavericks
    sha1 "dcba37116e8d490fd616b2ce2ff926158003408e" => :mountain_lion
    sha1 "4c546a1136fbb4ff3f669c87257bcbc1d34ea14a" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libbson"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
