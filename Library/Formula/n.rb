class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  head "https://github.com/tj/n.git"
  url "https://github.com/tj/n/archive/v1.3.0.tar.gz"
  sha256 "39a8c11efd24855364635f5447f83635355649556ed0af6b7ce8f4524cbd6e93"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
