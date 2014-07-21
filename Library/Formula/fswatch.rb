require "formula"

class Fswatch < Formula
  homepage "https://github.com/alandipert/fswatch"
  url "https://github.com/alandipert/fswatch/archive/1.3.8.tar.gz"
  sha1 "a34383a4c3340ba9495186124b469762758c8b27"

  bottle do
    sha1 "fdb17d25e0a20e3608b381a50462840e9a14bd33" => :mavericks
    sha1 "e7610c528ddf616f55298c4bb09d3799405e65c5" => :mountain_lion
    sha1 "3024b77fdf47035560674a9d2bc1405734518e06" => :lion
  end

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
