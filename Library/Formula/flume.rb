require 'formula'

class Flume < Formula
  url 'http://archive.cloudera.com/cdh/3/flume-0.9.3-CDH3B4.tar.gz'
  homepage 'https://github.com/cloudera/flume'
  md5 '54e0df9533579ef037f2b0b994fbcadf'
  version "0.9.3-CDH3B4"

  def flume_script
      <<-EOS.undent
      #!/bin/bash
      export FLUME_CONF_DIR=#{libexec}/conf
      exec #{libexec}/bin/flume $@
      EOS
  end

  def install
    libexec.install %w[bin conf lib webapps]
    libexec.install Dir["*.jar"]
    bin.mkpath
    (bin+"flume").write flume_script()
  end
end
