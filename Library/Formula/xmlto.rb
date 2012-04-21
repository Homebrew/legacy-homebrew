require 'formula'

class Xmlto < Formula
  homepage 'http://cyberelk.net/tim/software/xmlto/'
  url 'http://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.25.tar.bz2'
  sha1 '5d1aecd59d519066f94b4591722767c4e41bdc0f'

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
