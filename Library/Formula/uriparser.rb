require "formula"

class Uriparser < Formula
  homepage "http://uriparser.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uriparser/Sources/0.8.0.1/uriparser-0.8.0.1.tar.bz2"
  sha1 "53b16dd0640fda006ba4f9d750fec7e7c58836a9"

  bottle do
    cellar :any
    sha1 "c0894ffc030b1191aeeef9f06a9e8acf3980379d" => :mavericks
    sha1 "b024477e49c80eaba58fe01d7a099ac2945d62f7" => :mountain_lion
    sha1 "8b8e8966fff4358e9db0109b208d6d6d7e29c269" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make check"
    system "make install"
  end
end
