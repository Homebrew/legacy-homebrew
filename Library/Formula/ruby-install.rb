require 'formula'

class RubyInstall < Formula
  homepage 'https://github.com/postmodern/ruby-install#readme'
  url 'https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz'
  sha1 'be7dd5ad558102ab812addd3100a91c9812d0317'

  head 'https://github.com/postmodern/ruby-install.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
