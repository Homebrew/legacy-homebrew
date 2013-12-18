require 'formula'

class Xmltoman < Formula
  homepage 'http://sourceforge.net/projects/xmltoman/'
  url 'http://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz'
  sha1 '151f75d78d1fa53bca25b94dc00e46a27fabfee8'

  def install
    # generate the man files from their original XML sources
    system "./xmltoman xml/xmltoman.1.xml > xmltoman.1"
    system "./xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1"

    man1.install %w{ xmltoman.1 xmlmantohtml.1 }
    bin.install %w{ xmltoman xmlmantohtml }
    (share+'xmltoman').install %w(xmltoman.xsl xmltoman.dtd xmltoman.css)
  end
end

