require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-1.5.6.tgz'
  sha1 '146d114ff6359556ae5f720964aa091b39dbb506'

  def patches
    # fixes conflicting definitions of strdup()
    { :p0 => 'https://trac.macports.org/export/88419/trunk/dports/net/httping/files/patch-strndup.diff' }
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
