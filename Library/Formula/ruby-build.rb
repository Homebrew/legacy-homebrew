require 'formula'

class RubyBuild < Formula
  head 'https://github.com/sstephenson/ruby-build.git', :using => :git
  homepage 'https://github.com/sstephenson/ruby-build'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system './install.sh'
  end
end
