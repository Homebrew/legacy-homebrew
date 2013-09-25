require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://logstash.objects.dreamhost.com/release/logstash-1.2.1-flatjar.jar'
  sha1 '642374ef7c751c3a7089a9029b250df0da5a6574'

  def install
    libexec.install "logstash-#{version}-flatjar.jar"
    bin.write_jar_script libexec/"logstash-#{version}-flatjar.jar", "logstash"
  end
end
