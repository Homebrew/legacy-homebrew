require 'formula'

class Tdb < Formula
  url 'http://www.samba.org/ftp/tdb/tdb-1.2.9.tar.gz'
  homepage 'http://tdb.samba.org/'
  md5 '4d97d18bbe9040038d4e003495bb8cd1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
