require "formula"

class Hello < Formula
  homepage "http://www.gnu.org/software/hello/"
  url "http://ftpmirror.gnu.org/hello/hello-2.9.tar.gz"
  sha1 "cb0470b0e8f4f7768338f5c5cfe1688c90fbbc74"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
     system "#{bin}/hello", "--next-generation", "--greeting=brew"
  end
end
