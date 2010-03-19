require 'formula'

class Trafshow <Formula
  url 'ftp://ftp.FreeBSD.org/pub/FreeBSD/ports/distfiles/trafshow-4.0.tgz'
  homepage 'http://soft.risp.ru/trafshow/index_en.shtml'
  md5 '994355d6ba98d96ce06db9c92ae41669'

  def install
    system "./configure", "osx", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
		bin.install "trafshow"
		man1.install "trafshow.1"
  end
end
