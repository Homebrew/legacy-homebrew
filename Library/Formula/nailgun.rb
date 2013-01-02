require 'formula'

class Nailgun < Formula
  url 'http://downloads.sourceforge.net/project/nailgun/nailgun/0.7.1/nailgun-src-0.7.1.zip'
  homepage 'http://martiansoftware.com/nailgun/index.html'
  sha1 '70f2ae1faafe9cf060f2a44968960703475705e4'

  def script
    <<-EOS
#!/bin/bash
exec java -server -jar "#{prefix}/nailgun-0.7.1.jar"
    EOS
  end

  def install
    system "make"
    (bin+'ng-server').write script
    bin.install 'ng'
    prefix.install 'nailgun-0.7.1.jar'
  end
end
