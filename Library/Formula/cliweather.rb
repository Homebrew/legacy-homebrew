require 'formula'

class Cliweather < Formula
  url 'http://pub.lambda.ath.cx/patrick/cliweather/static/downloads/cliweather-2011.04.21.tar.gz'
  homepage 'http://closure.ath.cx/cliweather'
  md5 '62261bd8703d768a2fbef36d66f4bc08'

  def install
    bin.install "cliweather"
  end

  def test
    system "cliweather 98027"
  end
end
