require 'formula'

class TwoLame < Formula
  url 'http://downloads.sourceforge.net/twolame/twolame-0.3.12.tar.gz'
  homepage 'http://www.twolame.org/'
  md5 'd38c3ead5ac49b7425c1a9ef91126a35'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
