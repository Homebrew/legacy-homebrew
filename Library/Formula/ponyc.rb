class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.3.tar.bz2"
  sha256 "bdf6af248362bcb4b9d3869eca5b17b35ef1212786cc93a10efaace516bb6b3e"

  depends_on "llvm" => ["with-rtti"]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "--version"
  end
end
