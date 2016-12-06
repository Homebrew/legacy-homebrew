require 'formula'

class Chaosvpn < Formula
  depends_on 'tinc'

  head 'https://github.com/ryd/chaosvpn.git', :using => :git
  homepage 'http://wiki.hamburg.ccc.de/ChaosVPN'

  def install
    system "make"
    system "make install PREFIX=#{prefix} TINCDIR=#{etc}/tinc/"
  end
end
