class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/0.7.0.tar.gz"
  sha256 "0688fe4c13c65c6fa90989c57c04fafe34114889d2d100b6e62538e8f2b0dc02"

  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any
    sha256 "82bedf792a1362e3f2246d05157fd1db3b1329d70c55a85df4cdd2aa4f60bc7c" => :yosemite
    sha256 "5749360293db9b7ecec21cd6d5a13e6c152cac4f6e664251fc5f90c059108259" => :mavericks
    sha256 "946881e6e92d39ef2e998a2fa7e023f6bf1009191b53a02e7a0e273a18680e6b" => :mountain_lion
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/git-imerge", "-h"
  end
end
