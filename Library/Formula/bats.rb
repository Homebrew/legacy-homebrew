require 'formula'

class Bats < Formula
  homepage 'https://github.com/sstephenson/bats'
  url 'https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz'
  sha1 'cb8a5f4c844a5f052f915036130def31140fce94'
  head 'https://github.com/sstephenson/bats.git'

  def install
    system './install.sh', prefix
  end
end
