require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/releases/download/0.92.0/mongo-c-driver-0.92.0.tar.gz'
  sha1 'ca22f3ef44f1c8f6d23446936cc22027abc14dfc'

  depends_on 'pkg-config' => :build
  depends_on 'libbson'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
