class Typespeed < Formula
  desc "Zap words flying across the screen by typing them correctly"
  homepage "http://typespeed.sourceforge.net"
  url "https://downloads.sourceforge.net/project/typespeed/typespeed/0.6.5/typespeed-0.6.5.tar.gz"
  sha256 "5c860385ceed8a60f13217cc0192c4c2b4705c3e80f9866f7d72ff306eb72961"

  def install
    # Fix the hardcoded gcc.
    inreplace "src/Makefile.in", "gcc", ENV.cc
    inreplace "testsuite/Makefile.in", "gcc", ENV.cc
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
