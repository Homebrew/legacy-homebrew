require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://logstash.objects.dreamhost.com/release/logstash-1.1.13-flatjar.jar'
  sha1 '8eb1bde96a2d92b2c8157330858b4da190df8900'

  def install
    libexec.install "logstash-1.1.13-flatjar.jar"
    bin.write_jar_script libexec/'logstash-1.1.13-flatjar.jar', 'logstash'
  end
end
