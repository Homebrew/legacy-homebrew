require 'formula'

class Ii < Formula
  url 'http://dl.suckless.org/tools/ii-1.4.tar.gz'
  homepage 'http://tools.suckless.org/ii'
  md5 '535d88c23e84d510edf773db12728ac0'

  def install
    inreplace 'config.mk', '/usr/local', prefix
    system "make install"
  end
end
