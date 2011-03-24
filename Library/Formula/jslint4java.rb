require 'formula'

class Jslint4java < Formula
  url "http://jslint4java.googlecode.com/files/jslint4java-1.4.6-dist.zip"
  homepage 'http://code.google.com/p/jslint4java/'
  md5 '5cde5cb0d34c78d21ec19e7ffd6afc9c'
  version '1.4.6'

  def install
    prefix.install Dir['*']
    bin.mkpath
    (bin + 'jslint4java').write <<-EOF.undent
      #!/bin/bash
      java -jar #{prefix}/jslint4java-1.4.6.jar "$@"
    EOF
  end
end
