require 'formula'

class Elasticsearch < Formula
  url 'http://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.7.1.zip'
  homepage 'http://www.elasticsearch.com'
  md5 '2b01f7101a8df51f7d828ddd7054e9b0'

  def install
    FileUtils.rm_f Dir["bin/*.bat"]
    prefix.install %w[bin config lib]
  end
end
