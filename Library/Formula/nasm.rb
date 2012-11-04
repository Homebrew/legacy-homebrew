require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.10.05/nasm-2.10.05.tar.bz2'
  sha256 'de5af263ce344d3a89711c61802e3ad8a4e14a61d539f521f7554cdbbe04ed0f'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make everything"
    system "make install_everything"
  end
end
