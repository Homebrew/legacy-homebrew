require 'formula'

class Ivy < Formula
  homepage 'http://ant.apache.org/ivy/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.3.0-rc1/apache-ivy-2.3.0-rc1-bin.tar.gz'
  sha1 '6cdb7b8131ca3b13b0b6b43988f3ab92da2de6e7'
  version '2.3.0-rc1'

  def install
    libexec.install Dir['ivy*']
    doc.install Dir['doc/*']

    (bin+'ivy').write <<-EOS.undent
      #!/bin/sh
      java $JAVA_OPTS -jar "#{libexec}/ivy-#{version}.jar" "$@"
    EOS
  end
end
