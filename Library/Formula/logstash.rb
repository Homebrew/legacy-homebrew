require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://download.elasticsearch.org/logstash/logstash/logstash-1.3.2-flatjar.jar'
  sha1 'd49d48e0a9590eccb3b8acaa368c01f18125f33d'

  def install
    libexec.install "logstash-#{version}-flatjar.jar"
    bin.write_jar_script libexec/"logstash-#{version}-flatjar.jar", "logstash"
  end
end
