require 'formula'

class GitEncrypt < Formula
  homepage 'https://github.com/shadowhand/git-encrypt'
  head 'https://github.com/shadowhand/git-encrypt.git', :branch => 'develop'

  def install
    bin.install 'gitcrypt'
  end
end
