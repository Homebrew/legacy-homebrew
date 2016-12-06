require 'formula'

class Cdpr < Formula
  url 'http://downloads.sourceforge.net/project/cdpr/cdpr/2.4/cdpr-2.4.tgz'
  homepage 'http://www.monkeymental.com/'
  md5 'ee0f112e1a914168d088e4e0291efbcb'

  def install
    system "make"
    bin.install "cdpr"
  end
  
  def caveats
    "run cdpr sudo'd in order to avoid the error: 'No interfaces found! Make sure pcap is installed.'"
  end
end
