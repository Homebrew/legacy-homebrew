require 'formula'

class Orc < Formula
  homepage 'http://code.entropywave.com/projects/orc/'
  url 'http://code.entropywave.com/download/orc/orc-0.4.16.tar.gz'
  sha1 'b67131881e7834b0c820bfba468f668100fb2e91'

  def install
    # Fix compiling on 32 bit systems. See:
    # https://trac.macports.org/ticket/26881
    # https://github.com/mxcl/homebrew/issues/8848
    ENV["CFLAGS"] = "-Xarch_i386 -O1" #if Hardware.is_32_bit?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
