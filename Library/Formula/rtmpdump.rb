require 'formula'

class Rtmpdump <Formula
  url 'http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.2e.tar.gz'
  version '2.2e'
  homepage 'http://rtmpdump.mplayerhq.hu'
  md5 '10681c2fe41194a97d508d0e6bbfe74f'

  def install
    system "make SYS=posix"
    bin.install ['rtmpdump', 'rtmpgw', 'rtmpsrv', 'rtmpsuck']
  end
end