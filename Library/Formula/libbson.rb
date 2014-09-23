require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.0.0/libbson-1.0.0.tar.gz"
  sha1 "f1cd25e34426472ec3d8028edc6685fe77a81f5b"

  bottle do
    cellar :any
    sha1 "a18922a78071fec3010ded0a8bc8a096510d4e2e" => :mavericks
    sha1 "102eafc7b582a5868fe8e928d90b55381aca7d90" => :mountain_lion
    sha1 "45ec75c0a1587f1908f45e022c6e95201b214bc7" => :lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
