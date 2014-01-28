require 'formula'

class Gti < Formula
  homepage 'http://r-wos.org/hacks/gti'
  url 'https://github.com/rwos/gti/archive/v1.2.0.tar.gz'
  sha1 'c24e662486ccb4065ad36cab455d864cb17ecfc4'

  head 'https://github.com/rwos/gti.git'

  def install
    system 'make', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'gti'
  end
end
