require "formula"

class Unshield < Formula
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.0.tar.gz"
  sha1 "b9e09a23d7172dc43c914b764470aec182e4f468"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
