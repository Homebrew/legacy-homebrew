require 'formula'

class GitEncrypt < Formula
  homepage 'https://github.com/shadowhand/git-encrypt'
  url 'https://github.com/shadowhand/git-encrypt/archive/0.3.1.tar.gz'
  sha1 '2a9a0bff06c0ac1a95961cbf61c3efa1c926a294'

  head 'https://github.com/shadowhand/git-encrypt.git', :branch => 'master'

  def install
    bin.install 'gitcrypt'
  end
end
