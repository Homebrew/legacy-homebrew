require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/releases/download/0.90.0/libmongoc-0.90.0.tar.gz'
  sha1 '15e552b04f3e124fb80e1397e80ddb46fbf36a46'

  depends_on 'pkg-config' => :build
  depends_on 'libbson'

  def install
    # https://github.com/mongodb/mongo-c-driver/issues/5
    inreplace 'configure', 'enable_libclang=yes', 'enable_libclang=no'
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
