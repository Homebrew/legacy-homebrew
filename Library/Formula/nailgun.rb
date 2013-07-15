require 'formula'

class Nailgun < Formula
  homepage 'http://martiansoftware.com/nailgun/index.html'
  url 'http://downloads.sourceforge.net/project/nailgun/nailgun/0.7.1/nailgun-src-0.7.1.zip'
  sha1 '70f2ae1faafe9cf060f2a44968960703475705e4'

  def script; <<-EOS.undent
    #!/bin/bash
    exec java -server -jar "#{prefix}/nailgun-0.7.1.jar"
    EOS
  end

  def install
    system "make"
    (bin/'ng-server').write script
    bin.install 'ng'
    prefix.install 'nailgun-0.7.1.jar'
  end
end
