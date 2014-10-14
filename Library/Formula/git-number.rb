require "formula"

class GitNumber < Formula
  homepage "https://github.com/holygeek/git-number"
  url "https://github.com/holygeek/git-number/archive/1.0.0a.tar.gz"
  sha1 "d54c7e128bb9edb7eafe8791ad385badf963cefc"
  version "1.0.0a"

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end
end
