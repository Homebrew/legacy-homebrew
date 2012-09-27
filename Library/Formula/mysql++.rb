require 'formula'

class Mysqlxx < Formula
  url 'http://tangentsoft.net/mysql++/releases/mysql++-3.1.0.tar.gz'
  homepage 'http://tangentsoft.net/mysql++/'
  sha1 '9bd383ad932dce8cc1948ec76eed9036419d427f'

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
