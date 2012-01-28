require 'formula'

class Mysqlxx < Formula
  url 'http://tangentsoft.net/mysql++/releases/mysql++-3.1.0.tar.gz'
  homepage 'http://tangentsoft.net/mysql++/'
  md5 'd92769cc579b87a60e58a77099cc4f0e'

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
