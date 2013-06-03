require 'formula'

class Orc < Formula
  homepage 'http://code.entropywave.com/projects/orc/'
  url 'http://code.entropywave.com/download/orc/orc-0.4.17.tar.gz'
  sha1 '5cb7b3225a23bc4a5771a62e9c94a90d21609632'

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
