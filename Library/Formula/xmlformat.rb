require 'formula'

class Xmlformat < Formula
  url 'http://www.kitebird.com/software/xmlformat/xmlformat-1.04.tar.gz'
  homepage 'http://www.kitebird.com/software/xmlformat/'
  md5 '1703822838de817cead71f6ca2041137'

  def install
    bin.install "xmlformat.rb" => "xmlformat"
  end
end
