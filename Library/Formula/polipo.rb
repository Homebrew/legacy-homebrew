require 'formula'

class Polipo < Formula
  url 'http://freehaven.net/~chrisd/polipo/polipo-1.0.4.1.tar.gz'
  homepage 'http://www.pps.jussieu.fr/~jch/software/polipo/'
  head 'git://git.wifi.pps.jussieu.fr/polipo'
  md5 'bfc5c85289519658280e093a270d6703'

  def install
    cache_root = (var + "cache/polipo")
    cache_root.mkpath
    make_opts = "PREFIX=#{prefix} LOCAL_ROOT=#{share}/polipo/www DISK_CACHE_ROOT=#{cache_root} MANDIR=#{man} INFODIR=#{info} PLATFORM_DEFINES=-DHAVE_IPv6"
    system "make all #{make_opts}"
    system "make install #{make_opts}"
  end
end
