require 'formula'

class Bats < Formula
  homepage 'https://github.com/sstephenson/bats'
  url 'https://github.com/sstephenson/bats/tarball/v0.1.0'
  sha1 '240bcdae59f1d44cceb0cbe62c4815ad52da4672'
  head 'https://github.com/sstephenson/bats.git'

  def install
    bin.install Dir['bin/*']
    libexec.install Dir['libexec/*']
    prefix.install 'test'
  end

  def test
    system "bats #{prefix}/test/bats.bats"
  end
end
