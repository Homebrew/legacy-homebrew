require 'formula'

class Bats < Formula
  homepage 'https://github.com/sstephenson/bats'
  url 'https://github.com/sstephenson/bats/archive/v0.3.1.tar.gz'
  sha1 'f9c5d81e726b7ebb9c96d8546b1292a3af62ce4c'
  head 'https://github.com/sstephenson/bats.git'

  def install
    system './install.sh', prefix
  end
end
