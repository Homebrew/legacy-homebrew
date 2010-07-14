require 'formula'

class Pwgen <Formula
  url 'http://downloads.sourceforge.net/project/pwgen/pwgen/2.06/pwgen-2.06.tar.gz'
  homepage 'http://pwgen.sourceforge.net/'
  md5 '935aebcbe610fbc9de8125e7b7d71297'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
