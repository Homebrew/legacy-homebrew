require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20111030'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '3e0dd83a807de34ba83876cf25630fd1'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
