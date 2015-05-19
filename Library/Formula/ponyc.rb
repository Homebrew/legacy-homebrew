class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.5.tar.bz2"
  sha256 "5347b47106e50a451f962fae0063abb3fdd06d0c3235430d9543d48dc718e6cb"

  bottle do
    revision 1
    sha256 "dceed199973166120039b48d73df384b9b6d5cc087ed6762a4e0155dae3ce417" => :yosemite
    sha256 "14e784acf5b8ab11e346492eddde4bd6dfb5076dd1461be12acc8aaf5e2d44bb" => :mavericks
    sha256 "9248d2e58ccd3b5dd155c994d738b90cc18249239a220ea30b88a8e94fdcb6ef" => :mountain_lion
  end

  depends_on "llvm" => "with-rtti"
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "config=release", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
  end
end
