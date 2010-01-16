require 'formula'

class Sqlite <Formula
  url 'http://www.sqlite.org/sqlite-amalgamation-3.6.20.tar.gz'
  md5 '4bb3e9ee5d25e88b8ff8533fbeb168aa'
  homepage 'http://www.sqlite.org/'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end