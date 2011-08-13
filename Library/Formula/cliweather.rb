require 'formula'

class Cliweather < Formula
  url 'http://pub.lambda.ath.cx/patrick/cliweather/static/downloads/cliweather-2011.05.05.tar.gz'
  homepage 'http://closure.ath.cx/cliweather'
  md5 'faf9f16e86e48906708b07f381cedebc'

  def install
    bin.install "cliweather"
  end

  def test
    system "cliweather 98027"
  end
end
