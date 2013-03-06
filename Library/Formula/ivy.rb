require 'formula'

class Ivy < Formula
  homepage 'http://ant.apache.org/ivy/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.3.0/apache-ivy-2.3.0-bin.tar.gz'
  sha1 '878fab43ee9c70486a9ecec1ec44a2f034401687'

  def install
    libexec.install Dir['ivy*']
    doc.install Dir['doc/*']
    bin.write_jar_script libexec/'ivy-2.3.0.jar', 'ivy', '$JAVA_OPTS'
  end
end
