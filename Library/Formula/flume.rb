require 'formula'

class Flume < Formula
  homepage 'https://github.com/cloudera/flume'
  url 'http://archive.cloudera.com/cdh/3/flume-0.9.4-cdh3u2.tar.gz'
  version "0.9.4-cdh3u2"
  sha1 '9f68c8205b61e43d35467b6d45f815f5e41239e9'

  def flume_script
    <<-EOS.undent
      #!/bin/bash
      export FLUME_CONF_DIR=${FLUME_CONF_DIR-#{libexec}/conf}
      exec #{libexec}/bin/flume "$@"
    EOS
  end

  def install
    libexec.install %w[bin conf lib webapps]
    libexec.install Dir["*.jar"]
    (bin/"flume").write flume_script
  end
end
