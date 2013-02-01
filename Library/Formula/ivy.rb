require 'formula'

class Ivy < Formula
  homepage 'http://ant.apache.org/ivy/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.3.0-rc2/apache-ivy-2.3.0-rc2-bin.tar.gz'
  sha1 '12a2461ba801642ff44fa1b39c6a04d39b06552a'

  def install
    libexec.install Dir['ivy*']
    doc.install Dir['doc/*']
    bin.write_jar_script libexec/'ivy-2.3.0-rc2.jar', 'ivy', '$JAVA_OPTS'
  end
end
