require 'formula'

class Log4c < Formula
  homepage 'http://log4c.sourceforge.net/'
  url 'http://sourceforge.net/projects/log4c/files/log4c/1.2.1/log4c-1.2.1.tar.gz'
  sha1 'b380947047cd6f71bdec1afe57d7b285fb2a3f38'

  head 'cvs://:pserver:anonymous@log4c.cvs.sourceforge.net:/cvsroot/log4c:log4c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/log4c-config", "--version"
  end
end
