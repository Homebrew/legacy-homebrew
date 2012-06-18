require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://downloads.sourceforge.net/project/poco/sources/poco-1.4.3/poco-1.4.3p1-all.tar.gz'
  sha1 '893b26bdd2adee36d489ce1412bf67d5035f5b47'

  def install
    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
