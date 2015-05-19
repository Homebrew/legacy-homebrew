class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  head "https://github.com/tj/n.git"
  url "https://github.com/tj/n/archive/v1.3.0.tar.gz"
  sha1 "3c3248456bd6255401305d2cdf24898d78c28e25"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
