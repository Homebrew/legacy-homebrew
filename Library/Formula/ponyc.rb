class Ponyc < Formula
  homepage "http://www.ponylang.org"
  url "http://www.ponylang.org/releases/source/ponyc-0.1.2.tar.bz2"
  sha256 "224aa6d6c80574dd6074041eb7c6a83171862aea81d69ad1bf91f04d4f567d0a"

  depends_on "llvm"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "--version"
  end
end
