require 'brewkit'

class Sqlite <Formula
  @url='http://www.sqlite.org/sqlite-amalgamation-3.6.17.tar.gz'
  @md5='3172f8a23e7e7f0e5b295062e339a149'
  @homepage='http://www.sqlite.org/'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end