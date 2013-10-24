require 'formula'

class Log4c < Formula
  homepage 'http://log4c.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/log4c/log4c/1.2.3/log4c-1.2.3.tar.gz'
  sha1 '2f48a1b6ac551b295c1235fa463e80d747bee5e9'

  head 'cvs://:pserver:anonymous@log4c.cvs.sourceforge.net:/cvsroot/log4c:log4c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/log4c-config", "--version"
  end
end
