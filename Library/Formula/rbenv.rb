require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/tarball/v0.2.1'
  homepage 'https://github.com/sstephenson/rbenv'
  md5 '4b2ca757c7dcc6384a49d8947b97c4ed'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end
end
