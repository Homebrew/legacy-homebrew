require 'formula'

class Nhc98 <Formula
  url 'http://www.haskell.org/nhc98/nhc98src-1.22.tar.gz'
  homepage 'http://www.haskell.org/nhc98/'
  md5 '9c7669d3de6d217274ac4aadd63dce7e'

  def install
    ENV.j1
    ENV.m32
    ENV['LD'] = ENV['CC'] = '/usr/bin/i686-apple-darwin10-gcc-4.2.1'
    inreplace "Makefile", '-$(CC)', '-${BUILDCOMP}'

    system "./configure",
           "--prefix=#{prefix}",
           "--mandir=#{man}",
           "--buildwith=gcc",
           "--heap=8M"
    system "make all"
    system "make install"

    chmod 0755, bin+'nhc98-pkg'
    inreplace (bin+'nhc98-pkg'), "#{pwd}/script/harch", "#{bin}/harch"
    chmod 0555, bin+'nhc98-pkg'

    rm_f bin+'cabal-parse'
    ln_s "#{lib}/nhc98/ix86-Darwin10/cabal-parse", bin
  end
end
