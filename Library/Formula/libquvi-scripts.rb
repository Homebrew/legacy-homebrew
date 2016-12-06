require 'formula'

class LibquviScripts < Formula
  url 'http://downloads.sourceforge.net/project/quvi/0.4/libquvi-scripts/libquvi-scripts-0.4.1.tar.bz2'
  homepage 'http://quvi.sourceforge.net/'
  sha1 '3415f6e5bd367450f2bb8cfd49b718ebbb0a7ebb'


  def install
    system "./configure", "--prefix=#{prefix}", "--with-nsfw"
    system "make install"
  end
end
