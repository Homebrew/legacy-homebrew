require 'formula'

class Fondu <Formula
  url 'http://fondu.sourceforge.net/fondu_src-060102.tgz'
  md5 'e20861beacddc1ab392bef7813641bf8'
  homepage 'http://fondu.sourceforge.net/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    bin.install ['fondu', 'ufond']
    man1.install ['fondu.1', 'ufond.1']
  end
end
