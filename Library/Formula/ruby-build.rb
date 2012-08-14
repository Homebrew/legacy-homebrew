require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20120524'
  md5 '76999983d3d21b78306ce0fa863f1f32'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
