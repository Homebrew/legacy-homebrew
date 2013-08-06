require 'formula'

class Etl < Formula
  homepage 'http://synfig.org'
  url 'http://downloads.sourceforge.net/project/synfig/ETL/0.04.16/ETL-0.04.16.tar.gz'
  sha1 '1d80f0f8b16aab2f6a86b07be8a7b73da4c7f75f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
