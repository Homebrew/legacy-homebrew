require 'formula'

class RubyBuild < Formula
  head 'https://github.com/sstephenson/ruby-build.git'
  homepage 'https://github.com/sstephenson/ruby-build'

  def install
    bin.install Dir['bin/*']
    share.install Dir['share/*']
  end
end
