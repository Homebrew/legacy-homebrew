require 'formula'

class Flume < Formula
  url 'http://archive.cloudera.com/cdh/3/flume-0.9.4-cdh3u2.tar.gz'
  homepage 'https://github.com/cloudera/flume'
  md5 '6db17876879f419f769ec7bef4a1fad7'
  version "0.9.4-cdh3u2"

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
    bin.mkpath
    (bin+"flume").write flume_script()
  end
end
