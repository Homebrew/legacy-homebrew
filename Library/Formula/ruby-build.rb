require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20120216'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 'a65e73dee5929ffe4366352a9240f0b6'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
