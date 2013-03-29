require 'formula'

class GitEncrypt < Formula
  homepage 'https://github.com/shadowhand/git-encrypt'
  url 'https://github.com/shadowhand/git-encrypt/archive/0.3.0.tar.gz'
  sha1 '24ce80398c003c082a21402eddf9e73387b6f885'

  head 'https://github.com/shadowhand/git-encrypt.git', :branch => 'master'

  def install
    bin.install 'gitcrypt'
  end
end
