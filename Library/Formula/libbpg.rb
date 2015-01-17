require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.5.tar.gz"
  sha1 "1eee24f9d9d381b574b86a28d2af1073ab07bb55"

  bottle do
    cellar :any
    sha1 "86e6f94e92e03d116d260e8fcf06399b0ad93154" => :yosemite
    sha1 "b620193447e678cee2397193c52f0f38ba44a3a8" => :mavericks
    sha1 "297f3aa90675c20e1241da9adcf61e9cfafaf248" => :mountain_lion
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
