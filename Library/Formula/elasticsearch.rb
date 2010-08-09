require 'formula'

class Elasticsearch < Formula
  url 'http://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.9.0.zip'
  homepage 'http://www.elasticsearch.com'
  md5 'ad7e245cf2451b2c077c7529d6d5cdb2'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin config lib]
  end
end
