require 'formula'

class Polipo < Formula
  url 'http://freehaven.net/~chrisd/polipo/polipo-1.0.4.tar.gz'
  homepage 'http://www.pps.jussieu.fr/~jch/software/polipo/'
  head 'git://git.wifi.pps.jussieu.fr/polipo'
  md5 'defdce7f8002ca68705b6c2c36c4d096'

  def install
    cache_root = (var + "cache/polipo").mkpath
    make_opts = "PREFIX=#{prefix} LOCAL_ROOT=#{share}/polipo/www DISK_CACHE_ROOT=#{cache_root} MANDIR=#{man} INFODIR=#{info} PLATFORM_DEFINES=-DHAVE_IPv6"
    system "make all #{make_opts}"
    system "make install #{make_opts}"
  end
end
