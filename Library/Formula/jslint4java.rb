require 'formula'

class Jslint4java < Formula
  url "http://jslint4java.googlecode.com/files/jslint4java-2.0.2-dist.zip"
  homepage 'http://code.google.com/p/jslint4java/'
  md5 'e9a10b894bda3c03ac4c7184b98ae09b'

  def install
    libexec.install Dir['*']
    (bin+'jslint4java').write <<-EOF.undent
      #!/bin/bash
      java -jar "#{libexec}/jslint4java-2.0.2.jar" "$@"
    EOF
  end
end
