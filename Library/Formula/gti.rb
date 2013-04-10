require 'formula'

class Gti < Formula
  homepage 'http://r-wos.org/hacks/gti'
  url 'https://github.com/rwos/gti/archive/v1.0.4.tar.gz'
  sha1 '32005ae8bc8d10143b9078256463bc3aa9fa3a95'

  head 'https://github.com/rwos/gti.git'

  def install
    system 'make', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'gti'
  end
end
