require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-2.2.1.tgz'
  sha1 '9924bd2c1af4b8e2a4c33125323413f92866827d'

  def patches
    # fixes conflicting definitions of strdup()
    { :p0 => 'https://trac.macports.org/export/88419/trunk/dports/net/httping/files/patch-strndup.diff' }
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
