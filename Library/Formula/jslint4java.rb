require 'formula'

class Jslint4java < Formula
  url "http://jslint4java.googlecode.com/files/jslint4java-2.0.1-dist.zip"
  homepage 'http://code.google.com/p/jslint4java/'
  md5 '336ad583f83faa95d1c7bee2dff42d5c'
  version '2.0.1'

  def install
    prefix.install Dir['*']
    bin.mkpath
    (bin + 'jslint4java').write <<-EOF.undent
      #!/bin/bash
      java -jar #{prefix}/jslint4java-2.0.1.jar "$@"
    EOF
  end
end
