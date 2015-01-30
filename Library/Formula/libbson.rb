require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.1.0/libbson-1.1.0.tar.gz"
  sha1 "5f9b9449d795637601e7e8a2e0abd747a75c1f37"

  bottle do
    cellar :any
    sha1 "aeae3042023009d459e374b9f6aea4b2b374c341" => :yosemite
    sha1 "9600e435b74c33952c82b3fbdd66c492c0604414" => :mavericks
    sha1 "f4ed9c9dde8ba73e078a2eb642ad63be585b312c" => :mountain_lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
