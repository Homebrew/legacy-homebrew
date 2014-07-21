require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/0.98.0/libbson-0.98.0.tar.gz"
  sha1 "3e80019b8896669dc84781fe105438a3ccd2f483"

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
