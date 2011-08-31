require 'formula'

class Jslint4java < Formula
  url "http://jslint4java.googlecode.com/files/jslint4java-1.4.7-dist.zip"
  homepage 'http://code.google.com/p/jslint4java/'
  md5 '6dc5cf125641f84a05f3b89da6a650a3'
  version '1.4.7'

  def install
    prefix.install Dir['*']
    bin.mkpath
    (bin + 'jslint4java').write <<-EOF.undent
      #!/bin/bash
      java -jar #{prefix}/jslint4java-1.4.7.jar "$@"
    EOF
  end
end
