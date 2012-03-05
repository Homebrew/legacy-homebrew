require 'formula'

class Metapixel < Formula
  homepage 'http://www.complang.tuwien.ac.at/schani/metapixel/'
  url 'http://www.complang.tuwien.ac.at/schani/metapixel/files/metapixel-1.0.2.tar.gz'
  md5 'af5d77d38826756af213a08e3ada9941'

  depends_on 'jpeg'
  depends_on 'giflib'

  def install
    man1.mkpath
    # separate steps
    system "make", "CC=#{ENV.cc}",
                   "MACOS_LDOPTS=-L#{HOMEBREW_PREFIX}/lib",
                   "MACOS_CCOPTS=#{ENV.cflags} -I#{HOMEBREW_PREFIX}/include"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
