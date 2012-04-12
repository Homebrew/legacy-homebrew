require 'formula'

class Xmlto < Formula
  homepage 'http://cyberelk.net/tim/software/xmlto/'
  url 'http://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.23.tar.bz2'
  md5 '3001d6bb2bbc2c8f6c2301f05120f074'

  depends_on 'docbook'
  depends_on 'gnu-getopt'

  def install
    # GNU getopt is keg-only, so point configure to it
    ENV['GETOPT'] = Formula.factory('gnu-getopt').bin+"getopt"
    # Find our docbook catalog
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
