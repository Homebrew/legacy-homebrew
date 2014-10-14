require 'formula'

class Mysqlxx < Formula
  url 'http://tangentsoft.net/mysql++/releases/mysql++-3.2.0.tar.gz'
  homepage 'http://tangentsoft.net/mysql++/'
  sha1 '4bd50f5b8259b5f12e42d6a810e5941eaddaf24a'

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
