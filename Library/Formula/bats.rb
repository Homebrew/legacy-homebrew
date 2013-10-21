require 'formula'

class Bats < Formula
  homepage 'https://github.com/sstephenson/bats'
  url 'https://github.com/sstephenson/bats/archive/v0.3.0.tar.gz'
  sha1 'a40959400a288c9527e131409f6eb6bf3183c9ae'
  head 'https://github.com/sstephenson/bats.git'

  def install
    system './install.sh', prefix
  end
end
