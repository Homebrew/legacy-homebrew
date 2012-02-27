require 'formula'

class Httping < Formula
  url 'http://www.vanheusden.com/httping/httping-1.4.4.tgz'
  homepage 'http://www.vanheusden.com/httping/'
  md5 'e36bb30bd758c766d7260bdde6fe6450'

  def patches
    # fixes conflicting definitions of strdup()
    { :p0 => 'https://trac.macports.org/export/88419/trunk/dports/net/httping/files/patch-strndup.diff' }
  end

  def install
    system "make install PREFIX=#{prefix}"
  end
end
