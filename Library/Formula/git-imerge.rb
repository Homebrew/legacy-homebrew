class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/0.7.0.tar.gz"
  sha256 "0688fe4c13c65c6fa90989c57c04fafe34114889d2d100b6e62538e8f2b0dc02"

  head "https://github.com/mhagger/git-imerge.git"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/git-imerge", "-h"
  end
end
