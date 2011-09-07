require 'formula'

class Etl < Formula
  url 'https://downloads.sourceforge.net/project/synfig/ETL/0.04.13/ETL-0.04.13.tar.gz'
  homepage 'http://synfig.org'
  md5 'd52253adeb219d2fa554cbd744dfff29'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
