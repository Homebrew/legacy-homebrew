require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20120815'
  sha1 '13210ead44c1afc57759a3dfdbb5556629098ae4'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
