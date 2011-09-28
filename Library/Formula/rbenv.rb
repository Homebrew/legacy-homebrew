require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/tarball/v0.2.0'
  homepage 'https://github.com/sstephenson/rbenv'
  md5 'c26a72aa07ecf6cf51f1517f2c70a9dd'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end
end
