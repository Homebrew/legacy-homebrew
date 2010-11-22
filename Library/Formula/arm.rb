require 'formula'

class Arm < Formula
  homepage 'http://www.atagar.com/arm/'
  url 'http://www.atagar.com/arm/resources/arm-1.3.7-1.tar.bz2'
  sha256 '2d815dbf9608e501ab8d40f9f785c13308cd282821e36bda5bbbb62d548e0e0b'

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
