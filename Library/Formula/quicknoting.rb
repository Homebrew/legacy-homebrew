require 'formula'

class Quicknoting < Formula
  homepage 'https://github.com/downloads/Frogurth/QuickNoting'
  url 'https://github.com/downloads/Frogurth/QuickNoting/quicknoting-0.4.tar.gz'
  md5 '4700871f3e86b734488656e5da186494'
  depends_on 'scala'

  def install
    (bin+'quicknoting').write <<-EOS.undent
      #!/bin/bash
      exec java -jar "#{libexec}/quicknoting.jar" "$@"
    EOS

    libexec.install Dir['*']
  end
end
