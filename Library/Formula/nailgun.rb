require 'formula'

class Nailgun < Formula
  homepage 'http://martiansoftware.com/nailgun/index.html'
  url 'http://downloads.sourceforge.net/project/nailgun/nailgun/0.7.1/nailgun-src-0.7.1.zip'
  sha1 '70f2ae1faafe9cf060f2a44968960703475705e4'

  def install
    system "make"
    bin.install "ng"
    libexec.install "nailgun-#{version}.jar"
    bin.write_jar_script libexec/"nailgun-#{version}.jar", "ng-server", "-server"
  end
end
