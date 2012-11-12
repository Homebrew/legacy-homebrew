require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-1.5.3.tgz'
  sha1 '3606bb3b2d899c8f3fb178a295520e113bcb8e56'

  def patches
    # fixes conflicting definitions of strdup()
    { :p0 => 'https://trac.macports.org/export/88419/trunk/dports/net/httping/files/patch-strndup.diff' }
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
