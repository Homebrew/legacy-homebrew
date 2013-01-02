require 'formula'

class Lha < Formula
  url 'http://dl.sourceforge.jp/lha/22231/lha-1.14i-ac20050924p1.tar.gz'
  homepage 'http://lha.sourceforge.jp/'
  sha1 '2491c8b584c21759f1d3819f57fa0e1cbc235092'
  version '1.14i-ac20050924p1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
