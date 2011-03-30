require 'formula'

class Tcpstat < Formula
  head 'git://github.com/jtt/tcpstat.git'
  homepage 'http://github.com/jtt/tcpstat'

  def install
    system "make"
    bin.install 'tcpstat'
  end
end
