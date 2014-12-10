require 'formula'

class Ivy < Formula
  homepage 'http://ant.apache.org/ivy/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.3.0/apache-ivy-2.3.0-bin.tar.gz'
  sha1 '878fab43ee9c70486a9ecec1ec44a2f034401687'

  devel do
    url 'http://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.4.0-rc1/apache-ivy-2.4.0-rc1-bin.tar.gz'
    sha1 '69d6111a4ef2fa449d42d89c09f23456e6a6c0d9'
  end

  def install
    libexec.install Dir['ivy*']
    doc.install Dir['doc/*']
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
