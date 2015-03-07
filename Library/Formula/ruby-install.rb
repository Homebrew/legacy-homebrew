require 'formula'

class RubyInstall < Formula
  homepage 'https://github.com/postmodern/ruby-install#readme'
  url 'https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz'
  sha1 'd8061e46fe2ea40f867e219cdd7d28fea24f47ca'

  head 'https://github.com/postmodern/ruby-install.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
