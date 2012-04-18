require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/1.7.27/pngcrush-1.7.27.tar.bz2'
  md5 '582AB2B4C262B8837CC2D30BF7D14F33'

  def install
    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -I. -funroll-loops -fomit-frame-pointer -Wall -Wshadow -DZ_SOLO",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install 'pngcrush'
  end
end
