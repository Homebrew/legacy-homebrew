require 'formula'

class Etl < Formula
  url 'http://code.google.com/p/qtplay/downloads/detail?name=qtplay%201.4.0.zip'
  homepage 'https://sites.google.com/site/rainbowflight2/'
  md5 '280c0c4ebe433fbc682ea742e8af33a4'

  def install
    bin.install 'qtplay'
  end
end
