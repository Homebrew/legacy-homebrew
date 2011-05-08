require 'formula'

class Gant < Formula
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.3-_groovy-1.7.3.tgz'
  version '1.9.3'
  homepage 'http://gant.codehaus.org/'
  md5 '4a56ef11a7e7beaadbce59fe8510ef5b'

  depends_on 'groovy'

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    libexec.install %w[bin lib conf]
    (bin+'gant').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/gant
    EOS
  end
end
