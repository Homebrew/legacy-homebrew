require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar'
  sha1 '8effc7027093188b968fed37513ca647f96d6d8c'

  def install
    libexec.install "logstash-#{version}-flatjar.jar"
    bin.write_jar_script libexec/"logstash-#{version}-flatjar.jar", "logstash"
  end
end
