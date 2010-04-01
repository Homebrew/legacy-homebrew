require 'formula'

class Sqlite <Formula
  url 'http://www.sqlite.org/sqlite-amalgamation-3.6.23.tar.gz'
  md5 '8f1e86b3909a27f8122b0981afd16fcd'
  homepage 'http://www.sqlite.org/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end