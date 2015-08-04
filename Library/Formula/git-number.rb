class GitNumber < Formula
  desc "Use numbers for dealing with files in git"
  homepage "https://github.com/holygeek/git-number"
  url "https://github.com/holygeek/git-number/archive/1.0.0a.tar.gz"
  sha256 "710804466860fdb6f985c0a1268887230c4c1ff708584b19e385bbaec872f4f5"
  version "1.0.0a"

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end
end
