require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/master'
  homepage 'https://github.com/sstephenson/ruby-build'
  version '0.0.1'
  md5 '5c73d5e3f30087c793619616945a9ffd'

  def install
    ENV['PREFIX'] = '/usr/local/Cellar/ruby-build/0.0.1'
    system "./install.sh"
  end
end
