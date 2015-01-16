require "formula"

class Hello < Formula
  homepage "http://www.gnu.org/software/hello/"
  url "http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz"
  sha1 "f7bebf6f9c62a2295e889f66e05ce9bfaed9ace3"

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
