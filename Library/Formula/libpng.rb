require "formula"

class Libpng < Formula
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sf.net/project/libpng/libpng16/1.6.14/libpng-1.6.14.tar.xz"
  sha1 "9cc30ac84214fda2177a02da275359ffd5b068d9"

  bottle do
    cellar :any
    sha1 "08a5ef7f2c249c5da21de2d5405dab650d454f46" => :yosemite
    sha1 "bb4d97b044dff54ff2dfcba06e28d77951ca0306" => :mavericks
    sha1 "adb52fcc77e699a20e715c6eeaf5653fd27b9aca" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
