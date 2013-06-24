require 'formula'

class Gti < Formula
  homepage 'http://r-wos.org/hacks/gti'
  url 'https://github.com/rwos/gti/archive/v1.1.1.tar.gz'
  sha1 '93071cdeb6afc2d38c640ae60d95421207bc6368'

  head 'https://github.com/rwos/gti.git'

  def install
    system 'make', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'gti'
  end
end
