require 'formula'

class Elasticsearch < Formula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.16.0.tar.gz'
  homepage 'http://www.elasticsearch.com'
  md5 '5d719acd670d9ac3393d436c21bd0b58'

  skip_clean 'libexec/data'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end


  def install
    prefix.install %w{LICENSE.txt NOTICE.txt README.textile}
    libexec.install Dir['*']

    (bin+'elasticsearch').write startup_script('elasticsearch')
  end
end
