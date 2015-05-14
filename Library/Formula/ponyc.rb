class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.4.tar.bz2"
  sha256 "069ad47475f700346e3df8db640f19bc9eb7269088bcc6b95c3be40fe10ae402"

  depends_on "llvm" => ["with-rtti", "without-shared"]

  def install
    system "make", "install", "destdir=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/builtin"
  end
end
