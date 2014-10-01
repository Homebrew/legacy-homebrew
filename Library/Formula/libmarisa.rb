require "formula"

class Libmarisa < Formula
  homepage "https://code.google.com/p/marisa-trie/"
  url "https://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
  sha1 "fb0ed7d993e84dff32ec456a79bd36a00022629d"

  bottle do
    cellar :any
    sha1 "7488aa114b3c53ec5b2d11a7ebbc7196de0539a8" => :mavericks
    sha1 "c45d67cdca754912b77a8b0d9ac39095f3374da1" => :mountain_lion
    sha1 "3fc68e8e71c8696197f3f9dcb6daa0f98890cc56" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <marisa.h>
      int main() {
        marisa::Keyset keyset;
        keyset.push_back("a");
        keyset.push_back("app");
        keyset.push_back("apple");

        marisa::Trie trie;
        trie.build(keyset);

        marisa::Agent agent;
        agent.set_query("apple");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lmarisa", "-o", "test"
    system "./test"
  end
end
