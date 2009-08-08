require 'brewkit'

class Sqlite <Formula
  @url='http://www.sqlite.org/sqlite-amalgamation-3.6.16.tar.gz'
  @md5='f21ebadcca1e931212000661e64bb20c'
  @homepage='http://www.sqlite.org/'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end