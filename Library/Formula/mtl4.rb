require 'formula'

class Mtl4 < Formula
  homepage 'http://www.mtl4.org/'
  url 'http://www.simunova.com/downloads/mtl4/MTL-all-4.0.9338-Linux.tar.bz2'
  sha1 'f68fbff8629362edcc0d96e55f63afc1d0d30019'
  version '4.0.9338'

  def install
    prefix.install "usr/include"
    prefix.install "usr/share"
  end
end
