require 'formula'

class Pgdbf < Formula
  homepage 'http://pgdbf.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/pgdbf/pgdbf/0.6.1/pgdbf-0.6.1.tar.xz'
  md5 'fc4de726f44ce403c49ef184beaffe02'

  depends_on 'xz' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
