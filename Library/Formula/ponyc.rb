class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.5.tar.bz2"
  sha256 "5347b47106e50a451f962fae0063abb3fdd06d0c3235430d9543d48dc718e6cb"

  depends_on "llvm" => ["with-rtti", "without-shared"]
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
  end
end
