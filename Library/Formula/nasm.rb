require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.10.03/nasm-2.10.03.tar.bz2'
  sha256 '3babec15086fed1d00495e7c412848fd135cad70faa811738cb35da46d98974c'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make everything"
    system "make install_everything"
  end
end
