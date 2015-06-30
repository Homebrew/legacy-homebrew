class Dialog < Formula
  desc "Display user-friendly dialog boxes from shell scripts"
  homepage "http://invisible-island.net/dialog/"
  url "ftp://invisible-island.net/dialog/dialog-1.2-20150528.tgz"
  sha256 "a8cd7a66bdb41e53a3145cbb0eb370c5ce7300fe0e9ad6d3e8d3b9e16ff16418"

  bottle do
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end
end
