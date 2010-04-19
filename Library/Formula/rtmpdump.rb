require 'formula'

class Rtmpdump <Formula
  url 'http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.2b.tar.gz'
  homepage 'http://rtmpdump.mplayerhq.hu'
  md5 '1faea785e8818fe0ddf2543e05a4b801'

  def install
    system "make posix"
    bin.install ['rtmpdump', 'rtmpgw', 'rtmpsrv', 'rtmpsuck']
  end
end