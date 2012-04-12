require 'formula'

class Webfs < Formula
  url 'http://dl.bytesex.org/releases/webfs/webfs-1.21.tar.gz'
  homepage 'http://linux.bytesex.org/misc/webfs.html'
  md5 '6dc125fe160479404147e7bbfc781dbc'

  def patches
    {:p0 => "https://trac.macports.org/export/21504/trunk/dports/www/webfs/files/patch-ls.c"}
  end

  def install
    ENV["prefix"]=prefix
    system "make install mimefile=/etc/apache2/mime.types"
  end
end
