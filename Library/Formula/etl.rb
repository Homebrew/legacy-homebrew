require "formula"

class Etl < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.3/source/ETL-0.04.17.tar.gz"
  sha1 "cb7e83534274ef53ce841e8924f92048593e0cea"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
