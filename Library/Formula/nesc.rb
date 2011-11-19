require 'formula'

class Nesc < Formula
  url 'http://downloads.sourceforge.net/project/nescc/nescc/v1.3.3/nesc-1.3.3.tar.gz'
  homepage 'http://nescc.sourceforge.net/'
  md5 'f48a8b316de3f75ef1074c5585681f91'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
