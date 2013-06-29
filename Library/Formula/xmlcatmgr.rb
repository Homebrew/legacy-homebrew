require 'formula'

class Xmlcatmgr < Formula
  homepage 'http://xmlcatmgr.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmlcatmgr/xmlcatmgr/2.2/xmlcatmgr-2.2.tar.gz'
  sha1 '1761eb72234a14d3d919ce3ccb0c0550421bf2e8'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
