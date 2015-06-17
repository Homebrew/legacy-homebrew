require "formula"

class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.5.tar.gz"
  sha1 "1eee24f9d9d381b574b86a28d2af1073ab07bb55"

  bottle do
    cellar :any
    sha1 "b3484df329f2b40968a1d70f6a2b4e9df8b15c4d" => :yosemite
    sha1 "dc8a09cf7f7ebc452aa0d27caa78b4fb1d26b8c1" => :mavericks
    sha1 "ae5340b8b0a353282bafea08edce8146cf6d5106" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y"
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
