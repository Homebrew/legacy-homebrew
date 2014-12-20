require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.4.tar.gz"
  sha1 "6c1c950c0ff9a051e4f48bf2ff63f73bc859830d"

  bottle do
    cellar :any
    sha1 "b9c507c559617a5e916343aea3a943605626eefb" => :yosemite
    sha1 "256adcd800c53765e41b9bb302a0ff2f412a5e93" => :mavericks
    sha1 "4947077e367879313d4fed3f9e4c95988663a664" => :mountain_lion
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
