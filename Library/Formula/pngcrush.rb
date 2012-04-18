require 'formula'

class Pngcrush < Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url 'http://downloads.sourceforge.net/project/pmt/pngcrush/1.7.27/pngcrush-1.7.27.tar.bz2'
  md5 '582AB2B4C262B8837CC2D30BF7D14F33'

  def install
    ENV.append_to_cflags "-I. -funroll-loops -fomit-frame-pointer -Wall -Wshadow -DZ_SOLO" if ENV.compiler == :clang
    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install 'pngcrush'
  end
end
