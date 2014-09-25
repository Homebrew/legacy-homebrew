require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.0.0/libbson-1.0.0.tar.gz"
  sha1 "f1cd25e34426472ec3d8028edc6685fe77a81f5b"

  bottle do
    cellar :any
    sha1 "6c8c52c2a7067613ad78d325f16f938ea21e2627" => :mavericks
    sha1 "a0f4632571ed91cf3bba8506c2daf0d9558f0663" => :mountain_lion
    sha1 "34fe292661f52c29a29e2a9983834c5b4dac1e76" => :lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
