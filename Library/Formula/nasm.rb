require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.11/nasm-2.11.tar.bz2'
  sha256 '1ce7e897c67255a195367a60c739a90a0b33a4a73f058f7cda3253bcf975642b'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install install_rdf"
  end
end
