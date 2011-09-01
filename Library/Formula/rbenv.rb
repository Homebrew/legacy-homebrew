require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/tarball/v0.1.2'
  homepage 'https://github.com/sstephenson/rbenv'
  md5 '4f39199a353e350e3ca50a78de2fb73c'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end
end
