require "formula"

class Libtermkey < Formula
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.17.tar.gz"
  sha1 "2f9f0724cabd81f0ae3ba7b2837ee15dd40130f9"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
