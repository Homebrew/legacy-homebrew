require 'formula'

class Mysqlxx < Formula
  url 'http://tangentsoft.net/mysql++/releases/mysql++-3.2.1.tar.gz'
  homepage 'http://tangentsoft.net/mysql++/'
  sha1 '1ce5a4484b66d9852718412315e1409cafd8c397'

  depends_on 'mysql-connector-c'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{HOMEBREW_PREFIX}/lib",
                          "--with-mysql-include=#{HOMEBREW_PREFIX}/include"
    system "make install"
  end
end
