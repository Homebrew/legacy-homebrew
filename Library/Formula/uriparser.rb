require "formula"

class Uriparser < Formula
  homepage "http://uriparser.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uriparser/Sources/0.8.1/uriparser-0.8.1.tar.bz2"
  sha1 "4405d8baa0d9f5bc0319e6d5e68770acab67b602"

  bottle do
    cellar :any
    sha1 "4aa9b66b5ff2cd4cc32e3a43759fd27d85409750" => :yosemite
    sha1 "d12b3817d93aabbac1f4afad651ecf6ee05274f8" => :mavericks
    sha1 "f8d78d458c6579be32e769a4c1d0138ccbece282" => :mountain_lion
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
