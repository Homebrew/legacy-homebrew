require 'formula'

class Timelimit < Formula
  homepage 'http://devel.ringlet.net/sysutils/timelimit/'
  url 'http://devel.ringlet.net/sysutils/timelimit/timelimit-1.8.tar.gz'
  sha1 '0bc20606db0f587f3927f747680c9522b2d4c5af'

  def install
    system  "make", "LOCALBASE=#{prefix}",
                    "MANDIR=#{man}/man",
                    "all"
    bin.install "timelimit"
    man1.install "timelimit.1.gz"
  end
end
