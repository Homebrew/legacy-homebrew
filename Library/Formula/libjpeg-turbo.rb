require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class LibjpegTurbo < Formula
  homepage 'http://libjpeg-turbo.virtualgl.org/'
  url 'http://downloads.sourceforge.net/project/libjpeg-turbo/1.2.1/libjpeg-turbo-1.2.1.tar.gz'
  sha1 'a4992e102c6d88146709e8e6ce5896d5d0b5a361'

  depends_on :automake
  depends_on :autoconf
  depends_on "nasm"

  def install
    args = ["--host"]
    args << "x86_64-apple-darwin" << "NASM=#{HOMEBREW_PREFIX}/bin/nasm" if MacOS.prefer_64_bit?
    args << "i686-pc-linux-gnu" << "CFLAGS='-O3 -m32'" << "LDFLAGS=-m32" if !MacOS.prefer_64_bit?
    args << "--prefix=#{prefix}"

    system "./configure", *args
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end
