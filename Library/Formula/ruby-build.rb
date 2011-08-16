require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/master'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '8f1afdf0c1a0770a5b490be7e6a8a0f0'
  head 'https://github.com/sstephenson/ruby-build.git', :using => :git
  version '2011-08-15'

  def install
    ENV['PREFIX'] = prefix
    system "/bin/sh", "install.sh", prefix
  end
end
