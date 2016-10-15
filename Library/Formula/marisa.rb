require "formula"

class Marisa < Formula
  homepage "http://marisa-trie.googlecode.com"
  url "http://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
  sha1 "fb0ed7d993e84dff32ec456a79bd36a00022629d"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
