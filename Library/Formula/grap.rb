require "formula"

class Grap < Formula
  homepage "http://www.lunabase.org/~faber/Vault/software/grap/"
  url "http://www.lunabase.org/~faber/Vault/software/grap/grap-1.44.tar.gz"
  sha1 "b15e4e04525301cfbd2900b1f1a028e81a12ba92"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{share}/grap/examples"
    system "make", "install"
  end
end
