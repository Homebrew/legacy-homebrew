require 'formula'

class Pwgen < Formula
  url 'http://downloads.sourceforge.net/project/pwgen/pwgen/2.06/pwgen-2.06.tar.gz'
  homepage 'http://pwgen.sourceforge.net/'
  md5 '935aebcbe610fbc9de8125e7b7d71297'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
