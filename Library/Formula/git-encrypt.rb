require 'formula'

class GitEncrypt < Formula
  homepage 'https://github.com/shadowhand/git-encrypt'
  url 'https://github.com/shadowhand/git-encrypt.git', :tag => '0.3.0'
  version '0.3.0'

  head 'http://github.com/shadowhand/git-encrypt.git', :branch => 'master'

  def install
    bin.install 'gitcrypt'
  end

end

