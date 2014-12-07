require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.1.tar.gz"
  sha1 "0ece88372e178985d3327bbb7a0c94947586b3f1"

  bottle do
    cellar :any
    sha1 "5ce24008a63d1362c54f63765fefbf0fd8fcd2d0" => :yosemite
    sha1 "458ac4571970643dd81352d3a9591377c5004327" => :mavericks
    sha1 "8b906bd6b3f1537f6805e3bbd2df84dad93bcf43" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
