require 'formula'

class Nasm < Formula
  homepage 'http://www.nasm.us/'
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.10.07/nasm-2.10.07.tar.bz2'
  sha256 'c056e2abc83816892e448f9e9e95a3d21e9e096f44341b9d4853f62a443bba82'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install install_rdf"
  end
end
