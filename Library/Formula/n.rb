class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  head "https://github.com/tj/n.git"
  url "https://github.com/tj/n/archive/2.0.2.tar.gz"
  sha256 "217155e6a1e20461e0a2216ef8710cb4119e806814e4b0e86f4d5021195f132a"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
