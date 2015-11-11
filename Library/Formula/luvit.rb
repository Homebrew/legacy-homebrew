class Luvit < Formula
  desc "Asynchronous I/O for Lua (node.js style powered by luajit and libuv)"
  homepage "https://luvit.io/"
  url "https://lit.luvit.io/packages/luvit/luvit/v2.4.2.zip"
  sha256 "e4173ffae63b364c6f1c37fc4a7ce28880e4a4cda65f894cf436d268055fce17"

  depends_on "lit" => :build

  def install
    system "lit", "make", buildpath
    bin.install "luvit"
  end

  test do
    system "#{bin}/luvit", "-v"
  end
end

