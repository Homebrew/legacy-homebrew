require 'formula'

class Mp3wrap < Formula
  url 'http://superb-sea2.dl.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz'
  homepage 'http://mp3wrap.sourceforge.net/'
  md5 '096b46295cbe3ee2f02ca7792517dc36'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
