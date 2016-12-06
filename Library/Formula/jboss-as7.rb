require 'formula'

class JbossAs7 < Formula
  homepage 'http://www.jboss.org/as7'
  url 'http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip'
  md5 '175c92545454f4e7270821f4b8326c4e'
  version "7.1.1.Final"

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/standalone.sh" => "as7standalone"
    bin.install_symlink "#{libexec}/bin/domain.sh" => "as7domain"

    inreplace "#{libexec}/bin/standalone.conf",
      "#JAVA_OPTS=\"$JAVA_OPTS -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n\"",
      "JAVA_OPTS=\"$JAVA_OPTS -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n\""

    inreplace "#{libexec}/bin/standalone.conf",
        "#JAVA_HOME=\"/opt/java/jdk\"",
        "JAVA_HOME=\"$(/usr/libexec/java_home)\"\nJBOSS_HOME=\"#{libexec}\""

    inreplace "#{libexec}/bin/domain.conf",
        "#JAVA_HOME=\"/opt/java/jdk\"",
        "JAVA_HOME=\"$(/usr/libexec/java_home)\"\nJBOSS_HOME=\"#{libexec}\""
  end
end
