require 'formula'

class Polipo <Formula
  url 'http://freehaven.net/~chrisd/polipo/polipo-1.0.4.tar.gz'
  homepage 'http://www.pps.jussieu.fr/~jch/software/polipo/'
  head 'git://git.torproject.org/git/polipo'
  md5 'defdce7f8002ca68705b6c2c36c4d096'

  def install
    cache_root = (var + "cache/polipo").mkpath
    make_opts = "PREFIX=#{prefix} LOCAL_ROOT=#{share}/polipo/www DISK_CACHE_ROOT=#{cache_root} MANDIR=#{man}"
    system "make all #{make_opts}"
    system "make install #{make_opts}"
  end
end
