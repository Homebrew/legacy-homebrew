require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20111230'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '82241efbee5836419446c0ab78596b3a'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
