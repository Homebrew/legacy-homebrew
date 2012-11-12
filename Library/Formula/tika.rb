require 'formula'

class TikaRestServer < Formula
  url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.2/tika-server-1.2.jar'
  sha1 '1343e490a61f9223832c66ff384a35f73dbc719c'
end

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi/tika/tika-app-1.2.jar'
  sha1 '22c7110997d8ec114c6713cca1aadbbab6472c07'

  def install
    libexec.install 'tika-app-1.2.jar'
    bin.write_jar_script libexec/'tika-app-1.2.jar', 'tika'
    TikaRestServer.new.brew {
      libexec.install 'tika-server-1.2.jar'
      bin.write_jar_script libexec/'tika-server-1.2.jar', 'tika-rest-server'
    }
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
