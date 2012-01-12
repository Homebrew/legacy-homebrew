require 'formula'

class Etl < Formula
  url 'http://downloads.sourceforge.net/project/synfig/ETL/0.04.14/ETL-0.04.14.tar.gz'
  homepage 'http://synfig.org'
  md5 '7cb91905cbe07af327340aeba2226c06'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
