require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-2.1.tgz'
  sha1 '882f3d34680b5d03693e710c5c7ccdbb8a145a5f'

  def patches
    # fixes conflicting definitions of strdup()
    { :p0 => 'https://trac.macports.org/export/88419/trunk/dports/net/httping/files/patch-strndup.diff' }
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
