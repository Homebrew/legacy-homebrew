require "formula"

class Re2c < Formula
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.13.7.5/re2c-0.13.7.5.tar.gz"
  sha1 "4786a13be61f8249f4f388e60d94bb81db340d5c"

  bottle do
    cellar :any
    sha1 "a3246b77461757a1d03fce798dc0e96946dd8d4b" => :yosemite
    sha1 "295edf3bf8132c990a2d524132ce1cf0f4e22c38" => :mavericks
    sha1 "b289675f0bc4e76b1f131e82a7fe41f4d11804ed" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
