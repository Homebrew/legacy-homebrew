require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20110906.1'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '4e1077ffd9549d502a4ecc86d8360b87'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
