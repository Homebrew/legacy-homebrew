require 'formula'

class Gti < Formula
  homepage 'http://r-wos.org/hacks/gti'
  url 'https://github.com/rwos/gti/tarball/v1.0.4'
  sha1 '39a9780fc10663483f68ee6a4e69ad166ea21f62'

  head 'https://github.com/rwos/gti.git'

  def install
    system 'make', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'gti'
  end
end
