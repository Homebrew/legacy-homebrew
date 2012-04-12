require 'formula'

class GitEncrypt < Formula
  homepage 'https://github.com/shadowhand/git-encrypt'
  url 'https://github.com/shadowhand/git-encrypt/tarball/0.3.0'
  md5 '72d0e662eda75f26d8f84caffb11b2db'

  head 'http://github.com/shadowhand/git-encrypt.git', :branch => 'master'

  def install
    bin.install 'gitcrypt'
  end
end
