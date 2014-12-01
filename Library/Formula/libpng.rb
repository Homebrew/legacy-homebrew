require "formula"

class Libpng < Formula
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sf.net/project/libpng/libpng16/1.6.15/libpng-1.6.15.tar.xz"
  sha1 "bddeac8ca97fbcf54d6d32c6eefed5d94b49df88"

  bottle do
    cellar :any
    sha1 "daec718eb2f617cdf67d2347b05457ea361e35b3" => :yosemite
    sha1 "059d99d0321a8519252ae860667237a838d2a557" => :mavericks
    sha1 "9c87522225b3c94e3239d6a8a29c4c000dd29c2e" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
