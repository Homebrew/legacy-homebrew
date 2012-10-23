require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20121022'
  sha1 '925b8eee613076f0b36bd9612a1dfb2abe03ff3f'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
