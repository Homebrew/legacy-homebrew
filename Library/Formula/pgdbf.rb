require 'formula'

class Pgdbf < Formula
  homepage 'http://pgdbf.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/pgdbf/pgdbf/0.5.5/pgdbf-0.5.5.tar.gz'
  md5 '151ab6a2aaa6b54c8dcfc5548994c1e8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
