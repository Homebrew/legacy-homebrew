require 'formula'

class Cliweather < Formula
  url 'https://github.com/plukevdh/cliweather/tarball/v3.2.2012'
  homepage 'http://closure.ath.cx/cliweather'
  md5 'b31478a45f4edd68572e010938d63f73'

  def install
    bin.install "cliweather"
  end

  def test
    system "#{bin}/cliweather 98027"
  end
end
