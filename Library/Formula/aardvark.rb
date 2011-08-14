require 'formula'

class Aardvark < Formula
  url 'https://github.com/downloads/vark/Aardvark/aardvark-0.3.3.tgz'
  version '0.3.3'
  homepage 'http://vark.github.com/'
  md5 '4a84a92c954309c0788630397890bc5f'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end

  def install
    rm "bin/vark.cmd"
    rm "bin/vedit.cmd"
    libexec.install Dir['*']
    (bin+'vark').write startup_script('vark')
    (bin+'vedit').write startup_script('vedit')
  end
end
