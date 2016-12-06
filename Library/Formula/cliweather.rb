require 'formula'

class Cliweather < Formula
  url 'http://pub.lambda.ath.cx/patrick/cliweather/static/downloads/cliweather-2011.04.21.tar.gz'
  homepage ''
  md5 '62261bd8703d768a2fbef36d66f4bc08'

  # depends_on 'cmake'

  def install
    system "mkdir -p #{prefix}/bin"
    system "cp cliweather #{prefix}/bin"
  end
end
