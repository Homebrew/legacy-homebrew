require "formula"

class Re2c < Formula
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.13.7.4/re2c-0.13.7.4.tar.gz"
  sha1 "c9487d1ae4b6137ee1fda3db9400730af16b4c0d"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
