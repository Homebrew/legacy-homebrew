require 'formula'

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.7.jar'
  sha1 'd9516b1964be8775edbe0d6d167234c2967fea7a'

  resource 'server' do
    url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.7/tika-server-1.7.jar'
    sha1 'b99f9ee4c5b9bfcfc3411171f67e2dcaec13dcef'
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource('server')
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  def caveats; <<-EOS.undent
    To run Tika:
      tika

    To run Tika's REST server:
      tika-rest-server

    See the Tika homepage for more documentation:
      brew home tika
    EOS
  end
end
