class GitEncrypt < Formula
  desc "Transparent git encryption"
  homepage "https://github.com/shadowhand/git-encrypt"
  url "https://github.com/shadowhand/git-encrypt/archive/0.3.2.tar.gz"
  sha256 "a28ae0e023ae9c6629a12fde2a59710551956ab363b25d822b4e65351c066b83"
  head "https://github.com/shadowhand/git-encrypt.git"

  bottle :unneeded

  def install
    bin.install "gitcrypt"
  end
end
