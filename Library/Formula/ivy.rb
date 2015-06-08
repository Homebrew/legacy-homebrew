require 'formula'

class Ivy < Formula
  desc "Agile dependency manager"
  homepage 'http://ant.apache.org/ivy/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.4.0/apache-ivy-2.4.0-bin.tar.gz'
  sha1 '97a206e3b6ec2ce9793d2ee151fa997a12647c7f'

  def install
    libexec.install Dir['ivy*']
    doc.install Dir['doc/*']
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
