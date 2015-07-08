require "formula"

class GitEncrypt < Formula
  desc "Transparent git encryption"
  homepage "https://github.com/shadowhand/git-encrypt"
  url "https://github.com/shadowhand/git-encrypt/archive/0.3.2.tar.gz"
  sha1 "f15eca78cb2ea43bb4f258dea87fe3e6f2dd08b5"

  head "https://github.com/shadowhand/git-encrypt.git"

  def install
    bin.install "gitcrypt"
  end
end
