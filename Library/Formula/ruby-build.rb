require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build.git', :using => :git
  homepage 'https://github.com/sstephenson/ruby-build'
  version '0'

  def install
    ENV['PREFIX'] = prefix

    system './install.sh'
  end
end
