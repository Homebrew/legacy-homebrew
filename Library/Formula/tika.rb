require 'formula'

class TikaRestServer < Formula
  url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.2/tika-server-1.2.jar'
  sha1 '1343e490a61f9223832c66ff384a35f73dbc719c'
end

class Tika < Formula
  homepage 'http://tika.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi/tika/tika-app-1.2.jar'
  sha1 '22c7110997d8ec114c6713cca1aadbbab6472c07'

  def script; <<-EOS.undent
    #!/bin/sh
    java -jar #{libexec}/tika-app-1.2.jar "$@"
    EOS
  end

  def install
    libexec.install 'tika-app-1.2.jar'
    (bin+'tika').write script
    TikaRestServer.new.brew {
      libexec.install 'tika-server-1.2.jar'
      (bin+'tika-rest-server').write <<-EOS.undent
        #!/bin/sh
        java -jar #{libexec}/tika-server-1.2.jar "$@"
        EOS
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
