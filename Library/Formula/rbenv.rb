require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/tarball/v0.1.0'
  homepage 'https://github.com/sstephenson/rbenv'
  md5 '9193f11f8692277225a4acbec24f50b7'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']
  end
end
