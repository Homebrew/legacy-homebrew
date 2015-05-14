class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.3.tar.bz2"
  sha256 "bdf6af248362bcb4b9d3869eca5b17b35ef1212786cc93a10efaace516bb6b3e"

  depends_on "llvm" => ["with-rtti", "without-shared"]

  def install
    system "make", "install", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/collections"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/encode/base64"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/files"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/math"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/net/http"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/net/ssl"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/options"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/ponytest"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/random"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/regex"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/readline"
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/time"
  end
end
