require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20130225'
  sha1 'caa9a02488822b53c97ae2e53da639f305c1e3d0'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
