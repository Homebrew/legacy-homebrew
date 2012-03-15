require 'formula'

class Riemann < Formula
  homepage 'http://aphyr.github.com/riemann/'
  url 'http://aphyr.com/riemann/riemann-0.1.0.tar.bz2'
  md5 '5b4d8f2d6a443ae2258b8c569e26ebc6'

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
    prefix.install %w{ README.markdown etc/riemann.config.guide }
    etc.install Dir.glob('etc/*')

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
