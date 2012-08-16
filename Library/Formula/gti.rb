require 'formula'

class Gti < Formula
  homepage 'http://r-wos.org/hacks/gti'
  url 'https://github.com/rwos/gti/tarball/v1.0.3'
  sha1 '53ccd11466af6b859e5ec2ceec30f39bdc50c451'

  head 'git://github.com/rwos/gti.git'

  def install
    system 'make', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'gti'
  end
end
