require 'formula'

class Etl < Formula
  homepage 'http://synfig.org'
  url 'https://downloads.sourceforge.net/project/synfig/releases/0.64.1/source/ETL-0.04.17.tar.gz'
  sha1 '2ab2957140deaad90232533461513c5d425007bb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
