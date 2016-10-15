require "formula"

class Tta < Formula
  homepage "http://www.true-audio.com"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.2.tar.gz"
  sha1 "8d57bcad7ec22a83302080579bc96e49fec0f093"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-sse4"
    system "make", "install"
  end
end
