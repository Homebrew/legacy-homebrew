require "formula"

class Apib < Formula
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_0.tar.gz"
  sha1 "d7a5a2accd6bda7efeca433141b5df44ccd7f0b0"
  revision 1

  bottle do
    cellar :any
    sha1 "ffdea23d6f3e9627d3d99ec931d29f1e93f7dd9f" => :yosemite
    sha1 "d7443be34f3d7b9347c26bfdaae5c46eab41e3c8" => :mavericks
    sha1 "0952c22383ab1f4da194d66b823dd513a3f30ac8" => :mountain_lion
  end

  depends_on :apr => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "apib", "apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
