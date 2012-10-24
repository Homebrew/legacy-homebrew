require 'formula'

class FlumeNg < Formula
  homepage 'https://github.com/apache/flume'
  url 'http://archive.cloudera.com/cdh4/cdh/4/flume-ng-1.2.0-cdh4.1.0.tar.gz'
  sha1 '2217316f274ff615e9e7dc50f411d95edda60cc3'
  version "1.2.0-cdh4.1.0"
  
  def flume_ng_script
      <<-EOS.undent
      #!/bin/bash
      export FLUME_CONF_DIR=${FLUME_CONF_DIR-#{libexec}/conf}
      exec #{libexec}/bin/flume-ng "$@"
      EOS
  end
  
  def caveats
    <<-EOS.undent
    See https://cwiki.apache.org/FLUME/getting-started.html for example configurations.
    Your flume config dir is #{libexec}/conf/
    
    If you intend to sink data to S3, you will need to download a missing JAR:
        wget -O #{libexec}/lib/jets3t-0.7.1.jar http://repo1.maven.org/maven2/net/java/dev/jets3t/jets3t/0.7.1/jets3t-0.7.1.jar
    EOS
  end
  
  def install
    system "mvn", "compile"
    libexec.install %w[bin conf lib]
    bin.mkpath
    (bin + "flume-ng").write flume_ng_script()
  end
  
  def test
    system "flume-ng"
  end
end
