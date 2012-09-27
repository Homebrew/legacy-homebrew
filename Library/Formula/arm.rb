require 'formula'

class Arm < Formula
  homepage 'http://www.atagar.com/arm/'
  url 'http://www.atagar.com/arm/resources/static/arm-1.4.5.0.tar.bz2'
  sha256 'fc0e771585dde3803873b4807578060f0556cf1cac6c38840a714ffada3b28fa'

  def install
    (share+"arm").install Dir["*"]
    (bin+'arm').write <<-EOS.undent
      #!/bin/sh
      exec "#{share}/arm/arm" "$@"
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
