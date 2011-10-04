require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20110928'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '2f3cd506d0bb7a7e2cb6bbb36c81fdca'
  version 'v20110928'

  def install
    system "PREFIX=\"#{prefix}\" ./install.sh"
  end
end
