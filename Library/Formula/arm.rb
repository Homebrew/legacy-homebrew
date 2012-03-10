require 'formula'

class Arm < Formula
  homepage 'http://www.atagar.com/arm/'
  url 'https://archive.torproject.org/arm/arm-1.4.4.1.tar.bz2'
  sha256 'bdf4342d61d0f8a6395a5d7ee2e1471a5db9327c59d7cdc89315116045a3abf8'

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
