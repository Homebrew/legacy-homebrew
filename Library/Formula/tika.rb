require 'formula'

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.6.jar'
  sha1 '99df0d8c3f6a2be498d275053e611fb5afdf0a9d'

  resource 'server' do
    url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.6/tika-server-1.6.jar'
    sha1 '0e4a9fc0394b5a99b214423b6868d8eb6b0df7b0'
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
