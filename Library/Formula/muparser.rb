require 'formula'

class Muparser < Formula
  homepage 'http://muparser.beltoforion.de/'
  url 'https://docs.google.com/uc?export=download&confirm=no_antivirus&id=0BzuB-ydOOoduZjlFOEFRREZrT2s'
  sha1 '3974898052dd9ef350df1860f8292755f78f59df'
  version '2.2.3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
