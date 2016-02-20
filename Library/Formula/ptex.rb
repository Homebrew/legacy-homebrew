class Ptex < Formula
  desc "Texture mapping system"
  homepage "http://ptex.us"
  url "https://github.com/wdas/ptex/archive/v2.1.10.tar.gz"
  sha256 "0fb978e57f5e287c34b74896e3a9564a202d8806c75a18dd83855ba6d7c02122"

  depends_on "cmake" => :build

  def install
    system "make", "prefix=#{prefix}"
    system "make", "test"
    system "make", "install"
  end
end
