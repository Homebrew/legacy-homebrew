require 'formula'

class Webfs < Formula
  homepage 'http://linux.bytesex.org/misc/webfs.html'
  url 'http://dl.bytesex.org/releases/webfs/webfs-1.21.tar.gz'
  sha1 'a38880d8cb21e415244d220115ede7b573ac890c'

  patch :p0 do
    url "https://trac.macports.org/export/21504/trunk/dports/www/webfs/files/patch-ls.c"
    sha1 "0c408afff6df5b85f3c61afd4f44eb1944ba3a17"
  end

  def install
    ENV["prefix"]=prefix
    system "make install mimefile=/etc/apache2/mime.types"
  end
end
