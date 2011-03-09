require 'formula'

class Poco <Formula
  url 'http://downloads.sourceforge.net/project/poco/sources/poco-1.4.1/poco-1.4.1p1-all.tar.bz2'
  homepage 'http://pocoproject.org/'
  md5 '5b35baa1bf7ee4b20437b8950a1c5012'
  version '1.4.1p1'

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
