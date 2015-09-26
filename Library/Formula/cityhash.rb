class Cityhash < Formula
  desc "Hash functions for strings"
  homepage "https://code.google.com/p/cityhash/"
  url "https://cityhash.googlecode.com/files/cityhash-1.1.1.tar.gz"
  sha256 "76a41e149f6de87156b9a9790c595ef7ad081c321f60780886b520aecb7e3db4"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
