require 'formula'

class Jslint4java < Formula
  url "http://jslint4java.googlecode.com/files/jslint4java-2.0.2-dist.zip"
  homepage 'http://code.google.com/p/jslint4java/'
  sha1 'a632bc96c82dbaf11372f46649175e46bd0c3a47'

  def install
    libexec.install Dir['*']
    (bin+'jslint4java').write <<-EOF.undent
      #!/bin/bash
      java -jar "#{libexec}/jslint4java-2.0.2.jar" "$@"
    EOF
  end
end
