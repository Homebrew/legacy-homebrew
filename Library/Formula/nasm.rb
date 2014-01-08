require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.10.09/nasm-2.10.09.tar.bz2'
  sha256 '7141180d3874b5967c6a60191e8d45fba9cc86bd60a4803ad80b6b6b3eac36b9'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install install_rdf"
  end
end
