require 'formula'

class Sqlite <Formula
  url 'http://www.sqlite.org/sqlite-amalgamation-3.6.22.tar.gz'
  md5 'b683b3903e79ab8a6d928dc9d4a56937'
  homepage 'http://www.sqlite.org/'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end