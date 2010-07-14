require 'formula'

class Poco <Formula
  url 'http://downloads.sourceforge.net/project/poco/sources/poco-1.3.6/poco-1.3.6p2-all.tar.bz2'
  homepage 'http://pocoproject.org/'
  md5 '8f1a6c3511764167d39f1950da3fcb37'
  version '1.3.6p2'

  def install
    arch = Hardware.is_64_bit? ? 'Darwin_x86_64': 'Darwin'

    system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--config=#{arch}",
        "--omit=Data/MySQL,Data/ODBC",
        "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
