require 'formula'

class Elasticsearch < Formula
  url 'http://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.8.0.zip'
  homepage 'http://www.elasticsearch.com'
  md5 '0b9f0361163847a6580658c59cbfcc51'

  def install
    FileUtils.rm_f Dir["bin/*.bat"]
    prefix.install %w[bin config lib]
  end
end
