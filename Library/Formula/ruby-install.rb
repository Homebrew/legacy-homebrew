require 'formula'

class RubyInstall < Formula
  homepage 'https://github.com/postmodern/ruby-install#readme'
  url 'https://github.com/postmodern/ruby-install/archive/v0.2.1.tar.gz'
  sha1 'f463c92051797c7cf78a1403f409b91d03a01be6'

  head 'https://github.com/postmodern/ruby-install.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
