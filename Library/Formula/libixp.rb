require 'formula'

class Libixp <Formula
  url 'http://dl.suckless.org/libs/libixp-0.4.tar.gz'
  homepage 'http://libs.suckless.org/libixp'
  md5 '59d9e918adffaf4413b32ac4f66724fd'

  def install
    system "sed -i '.bak' -e \"s|/usr/local|#{prefix}|g\" config.mk"
    system "make"
    system "make install"
  end
end
