require 'formula'

class Kytea < Formula
  url 'http://www.phontron.com/kytea/download/kytea-0.3.2.tar.gz'
  homepage 'http://www.phontron.com/kytea/'
  md5 '14fb920c60f7abd9ce4c08037cc1be13'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
