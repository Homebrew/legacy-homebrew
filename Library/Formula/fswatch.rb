require "formula"

class Fswatch < Formula
  homepage "https://github.com/alandipert/fswatch"
  url "https://github.com/alandipert/fswatch/archive/v1.3.2.tar.gz"
  sha1 "af52fd305b80bc5e05217edb1d8cdce02fdb4e91"

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
