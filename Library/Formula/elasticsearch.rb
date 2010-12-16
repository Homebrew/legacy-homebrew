require 'formula'

class Elasticsearch < Formula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.13.0.zip'
  homepage 'http://www.elasticsearch.com'
  md5 'fd57261871c5be3c3053428046a86bc6'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin config lib]
  end
end
