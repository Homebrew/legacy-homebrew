require "formula"

class Esniper < Formula
  homepage "http://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.31.0/esniper-2-31-0.tgz"
  version "2.31"
  sha1 "0360604d003ace99e8abf7e4d1fb00a8f1129760"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
