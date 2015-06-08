require 'formula'

class Tika < Formula
  desc "Content analysis toolkit"
  homepage 'https://tika.apache.org/'
  url 'https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.8.jar'
  sha256 '9346cf68c00a46b2e6189794d5fb2e127bf9b60ef6d216edf06e01917f7deaef'

  resource 'server' do
    url 'http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.8/tika-server-1.8.jar'
    sha256 'ac0b1207284b7bd591acb0b7453081cbb1ea143c650678927ffe1463be659305'
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
