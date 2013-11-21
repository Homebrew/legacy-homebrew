require 'formula'

class RubyInstall < Formula
  homepage 'https://github.com/postmodern/ruby-install#readme'
  url 'https://github.com/postmodern/ruby-install/archive/v0.3.1.tar.gz'
  sha1 'e7e8a8b7e7138c6d364367a161dbb5a0a2bceda8'

  head 'https://github.com/postmodern/ruby-install.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
