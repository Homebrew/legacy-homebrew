require 'formula'

class Elasticsearch < Formula
  url 'http://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.6.0.zip'
  homepage 'http://www.elasticsearch.com'
  md5 'e3657a1970695c3d043341484b338af3'

  def install
    FileUtils.rm_f Dir["bin/*.bat"]
    prefix.install %w[bin config lib]
  end
end
