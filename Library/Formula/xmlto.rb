require 'formula'

class Xmlto < Formula
  url 'http://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.23.tar.bz2'
  md5 '3001d6bb2bbc2c8f6c2301f05120f074'
  homepage 'http://cyberelk.net/tim/software/xmlto/'

  depends_on 'docbook'
  depends_on 'gnu-getopt'

  def install
    docbook = Formula.factory "docbook"
    getopt = Formula.factory "gnu-getopt"

    unless File.exist? "/private/etc/xml/catalog"
      opoo "You must to register docbook"
      puts docbook.caveats
      exit 99
    end

    # GNU getopt is keg-only, so point configure to it
    ENV['GETOPT']=getopt.bin+"getopt"

    ENV.j1
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"

    system "make install"
  end

  def caveats
    docbook = Formula.factory "docbook"
    <<-EOS.undent
      xmlto requires that docbook be installed and registered.

      See:
        brew info docbook
    EOS
  end
end
