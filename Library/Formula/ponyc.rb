class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.1.tar.bz2"
  sha256 "8ed8e5139635cf7f60cf87d51fd36210ab11a8a7fcefbdfa9b5c25a2666bee1e"

  depends_on "llvm"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "--version"
  end
end
