require 'formula'

class Xmltoman < Formula
  url 'http://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz'
  homepage 'http://sourceforge.net/projects/xmltoman/'
  md5 '99be944b9fce40b3fe397049bf14a097'

  def install
    # generate the man files from their original XML sources
    system "./xmltoman xml/xmltoman.1.xml > xmltoman.1"
    system "./xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1"

    man1.install %w{ xmltoman.1 xmlmantohtml.1 }
    bin.install %w{ xmltoman xmlmantohtml }
    (share+'xmltoman').install %w(xmltoman.xsl xmltoman.dtd xmltoman.css)
  end
end

