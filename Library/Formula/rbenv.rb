require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/tarball/v0.1.1'
  homepage 'https://github.com/sstephenson/rbenv'
  md5 '3a53a4f7397d124bf2119bf2237028b3'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end
end
