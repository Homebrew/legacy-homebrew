require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/releases/download/0.96.2/mongo-c-driver-0.96.2.tar.gz'
  sha1 '6a69db4d2e5e2fc68fd2959666802786111c9275'

  bottle do
    cellar :any
    sha1 "4f02db86827e0f95979f027c2bb44c3fd19ae463" => :mavericks
    sha1 "dcba37116e8d490fd616b2ce2ff926158003408e" => :mountain_lion
    sha1 "4c546a1136fbb4ff3f669c87257bcbc1d34ea14a" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libbson'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
