require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/releases/download/0.96.2/mongo-c-driver-0.96.2.tar.gz'
  sha1 '6a69db4d2e5e2fc68fd2959666802786111c9275'

  bottle do
    cellar :any
    sha1 "2b47b10f5acee744bfbe52edefa43a5026569d72" => :mavericks
    sha1 "e7bcfd6172bf4791636157e4671bcf6cb4a02540" => :mountain_lion
    sha1 "c60ea467d0f9765ae489f6c9687b606b92c6c330" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libbson'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
