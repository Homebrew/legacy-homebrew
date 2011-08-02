require 'formula'

class Rhino < Formula
  url 'ftp://ftp.mozilla.org/pub/mozilla.org/js/rhino1_7R3.zip'
  homepage 'http://www.mozilla.org/rhino/'
  md5 '99d94103662a8d0b571e247a77432ac5'
  version '1.7R3'

  def install
    libexec.install 'js.jar'
    (bin+'rhino').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/js.jar" $@
    EOS
  end
end
