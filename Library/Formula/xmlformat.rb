require 'formula'

class Xmlformat < Formula
  homepage 'http://www.kitebird.com/software/xmlformat/'
  url 'http://www.kitebird.com/software/xmlformat/xmlformat-1.04.tar.gz'
  sha1 '405057df0b8160775d486b671348820359b4b85d'

  def install
    bin.install "xmlformat.pl" => "xmlformat"
  end
end
