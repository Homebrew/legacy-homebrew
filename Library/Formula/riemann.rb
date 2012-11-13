require 'formula'

class Riemann < Formula
  homepage 'http://aphyr.github.com/riemann/'
  url 'http://aphyr.com/riemann/riemann-0.1.3.tar.bz2'
  md5 'b358ca34382f34752b9ceaa27e2c0363'

  def shim_script
    <<-EOS.undent
      #!/bin/bash
      if [ -z "$1" ]
      then
        config="#{etc}/riemann.config"
      else
        config=$@
      fi
      exec "#{libexec}/bin/riemann" "$config"
    EOS
  end

  def install
    # Keep a current reference copy of riemann.config handy
    etc.install 'etc/riemann.config' => 'riemann.config.guide'
    if File.exists?(etc/'riemann.config')
    # Don't overwrite the config file; the user may have tweaked it.
      ohai "Your riemann.config is untouched; refer to riemann.config.guide for new options"
    else
      cp etc/'riemann.config.guide', etc/'riemann.config'
    end
    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    (bin+'riemann').write shim_script
  end

  def caveats; <<-EOS.undent
    You may also wish to install these Ruby gems:
      riemann-client
      riemann-tools
      riemann-dash
    EOS
  end
end
