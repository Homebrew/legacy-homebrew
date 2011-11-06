require 'formula'

class Libcddb < Formula
  url 'http://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2'
  md5 '8bb4a6f542197e8e9648ae597cd6bc8a'
  homepage 'http://libcddb.sourceforge.net/'

  depends_on 'pkg-config' => :build
  depends_on 'libcdio'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
