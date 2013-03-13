require 'formula'

class Webfs < Formula
  homepage 'http://linux.bytesex.org/misc/webfs.html'
  url 'http://dl.bytesex.org/releases/webfs/webfs-1.21.tar.gz'
  sha1 'a38880d8cb21e415244d220115ede7b573ac890c'

  def patches
    {:p0 => "https://trac.macports.org/export/21504/trunk/dports/www/webfs/files/patch-ls.c"}
  end

  def install
    ENV["prefix"]=prefix
    system "make install mimefile=/etc/apache2/mime.types"
  end
end
