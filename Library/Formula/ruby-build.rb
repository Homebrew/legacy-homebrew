require 'formula'

class RubyBuild < Formula
  url 'https://github.com/sstephenson/ruby-build/tarball/v20110928'
  homepage 'https://github.com/sstephenson/ruby-build'
  md5 '2f3cd506d0bb7a7e2cb6bbb36c81fdca'

  head 'https://github.com/sstephenson/ruby-build.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
