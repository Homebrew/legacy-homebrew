require 'formula'

class Log4c < Formula
  homepage 'http://log4c.sourceforge.net/'
  url 'http://sourceforge.net/projects/log4c/files/log4c/1.2.2/log4c-1.2.2.tar.gz'
  sha1 '39fb1d4ffb4c3b33235e5d6ecc9fddd217d51137'

  head 'cvs://:pserver:anonymous@log4c.cvs.sourceforge.net:/cvsroot/log4c:log4c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/log4c-config", "--version"
  end
end
