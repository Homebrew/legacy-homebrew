require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/5effdc334a5f248dd15ab4304c51e3c50b78bfb1'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '7fb48257cac41644b48be28b0ea9f945'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install

    # Set prefix for install ruby-build
    ENV["PREFIX"] = prefix

    system "./install.sh"
  end
end
