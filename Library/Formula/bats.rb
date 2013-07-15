require 'formula'

class Bats < Formula
  homepage 'https://github.com/sstephenson/bats'
  url 'https://github.com/sstephenson/bats/archive/v0.2.0.tar.gz'
  sha1 'c2e67181e2bd6f89f9e40d4cad43c0fe2c1df19a'
  head 'https://github.com/sstephenson/bats.git'

  def install
    system './install.sh', prefix
  end
end
