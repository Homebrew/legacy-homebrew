require 'formula'

class Xmlcatmgr < Formula
  url 'http://downloads.sourceforge.net/project/xmlcatmgr/xmlcatmgr/2.2/xmlcatmgr-2.2.tar.gz'
  homepage 'http://xmlcatmgr.sourceforge.net'
  md5 '4b0c7e075f5ff5aa86537b403468739a'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
