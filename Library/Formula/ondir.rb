class Ondir < Formula
  desc "Automatically execute scripts as you traverse directories"
  homepage "http://swapoff.org/ondir.html"
  head "https://github.com/alecthomas/ondir.git"
  url "http://swapoff.org/files/ondir/ondir-0.2.3.tar.gz"
  sha256 "504a677e5b7c47c907f478d00f52c8ea629f2bf0d9134ac2a3bf0bbe64157ba3"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
