require 'formula'

class Fondu < Formula
  homepage 'http://fondu.sourceforge.net/'
  url 'http://fondu.sourceforge.net/fondu_src-060102.tgz'
  md5 'e20861beacddc1ab392bef7813641bf8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install 'fondu', 'ufond'
    man1.install 'fondu.1', 'ufond.1'
  end
end
