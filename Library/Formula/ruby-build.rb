require 'formula'

class RubyBuild < Formula
  head 'https://github.com/sstephenson/ruby-build.git'
  homepage 'https://github.com/sstephenson/ruby-build'

  def install
    system "PREFIX=#{prefix} ./install.sh"
  end
end
