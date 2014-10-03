require "formula"

class Re2c < Formula
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.13.7.5/re2c-0.13.7.5.tar.gz"
  sha1 "4786a13be61f8249f4f388e60d94bb81db340d5c"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
