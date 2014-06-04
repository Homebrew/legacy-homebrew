require "formula"

class Fswatch < Formula
  homepage "https://github.com/alandipert/fswatch"
  url "https://github.com/alandipert/fswatch/archive/1.3.5.tar.gz"
  sha1 "e22d0d21c563dab03f1339ad64530c6358780516"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
