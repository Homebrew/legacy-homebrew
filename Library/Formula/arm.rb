require 'formula'

class Arm < Formula
  homepage 'http://www.atagar.com/arm/'
  url 'http://www.atagar.com/arm/resources/arm-1.4.3.0.tar.bz2'
  sha256 'e543fcd75cdce8cf7bab3c50769d2a06d1ac8e8cc6927be7173a65a1e87abce0'

  def install
    (share+"arm").mkpath
    (share+"arm").install Dir["*"]

    (bin+'arm').write <<-EOS
#!/bin/sh
cd #{share}/arm; arm $@
    EOS
  end

  def caveats; <<-EOS.undent
    You'll need to enable the Tor Control Protocol in your torrc.
    See here for details: http://www.torproject.org/tor-manual.html.en

    To configure Arm, copy the sample configuration from
    #{share}/arm/armrc.sample
    to ~/.armrc, adjusting as needed.
    EOS
  end
end
