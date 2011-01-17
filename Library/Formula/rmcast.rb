require 'formula'

class Rmcast <Formula
  url 'http://www.land.ufrj.br/tools/rmcast/download/rmcast-2.0.0.tar.gz'
  homepage 'http://www.land.ufrj.br/tools/rmcast/rmcast.html'
  md5 '358001b1cb56a9eb23a929477655ab89'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
