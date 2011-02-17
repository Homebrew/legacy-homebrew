require 'formula'

class Elasticsearch < Formula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.14.2.tar.gz'
  homepage 'http://www.elasticsearch.com'
  md5 'b43789473b130fdecdf228f4120604a7'

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
