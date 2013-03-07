require 'formula'

class GitEncrypt < Formula
  homepage 'https://github.com/shadowhand/git-encrypt'
  url 'https://github.com/shadowhand/git-encrypt/tarball/0.3.0'
  sha1 '3b06d626e1eb33651de24ead3a5a9b10cdd8278a'

  head 'https://github.com/shadowhand/git-encrypt.git', :branch => 'master'

  def install
    bin.install 'gitcrypt'
  end
end
