require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20110914'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '8056b7b157c4c660fab8d1324cb02540'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
