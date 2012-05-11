require 'formula'

class Mp3check < Formula
  url 'http://jo.ath.cx/soft/mp3check/mp3check-0.8.4.tgz'
  homepage 'http://jo.ath.cx/soft/mp3check/'
  md5 'dcaf1926463d5dfb81bd8a96cd3f9ceb'

  def install
    ENV.deparallelize

    system 'make'
    bin.install 'mp3check'
  end
end
