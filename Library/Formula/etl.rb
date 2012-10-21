require 'formula'

class Etl < Formula
  homepage 'http://synfig.org'
  url 'http://downloads.sourceforge.net/project/synfig/ETL/0.04.15/ETL-0.04.15.tar.gz'
  sha1 'fee4f4152d57a8843163963dc587bca44c5ab0e4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
