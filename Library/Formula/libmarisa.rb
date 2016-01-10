class Libmarisa < Formula
  desc "Static and space-efficient trie data structure"
  homepage "https://code.google.com/p/marisa-trie/"
  url "https://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
  sha256 "67a7a4f70d3cc7b0a85eb08f10bc3eaf6763419f0c031f278c1f919121729fb3"

  bottle do
    cellar :any
    revision 1
    sha256 "7f64d134b201a2791f49db66452ddeaad60310cc44df117830a5671459f535e8" => :yosemite
    sha256 "8255b1f73c5fa15b3f7c7f5a61d54e8acc781f7bce98911f64faf4a2228e952f" => :mavericks
    sha256 "64a82f591bea1b75e3146080a713b6d919cfd5143167061c602b277a47a576b0" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
