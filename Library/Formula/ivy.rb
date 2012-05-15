require 'formula'

class Ivy < Formula
  homepage 'http://ant.apache.org/ivy/'
  url 'http://www.apache.org/dist/ant/ivy/2.2.0/apache-ivy-2.2.0-bin.tar.gz'
  md5 '80d87a17006518a762ceeb88b692cbe6'

  def install
    libexec.install Dir['ivy*']
    doc.install Dir['doc/*']

    (bin+'ivy').write <<-EOS.undent
      #!/bin/sh
      java $JAVA_OPTS -jar "#{libexec}/ivy-#{version}.jar" "$@"
    EOS
  end

  def test
    system "#{bin}/ivy", "-version"
  end
end
