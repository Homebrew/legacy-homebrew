require 'formula'

class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.11/bin/apache-tomcat-8.0.11.tar.gz"
  sha1 "a0857a830dd66ccd417fd3910edf787f57a37ce3"

  bottle do
    cellar :any
    sha1 "bdf205dceacb04661304619b5bcc71316690fffd" => :mavericks
    sha1 "f3b897bb5c1e13ba831eca0cf3a46dfc3419c839" => :mountain_lion
    sha1 "078f0a759f496a0fe51ae7e07916a5eff21f1b76" => :lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.11/bin/apache-tomcat-8.0.11-fulldocs.tar.gz"
    version "8.0.11"
    sha1 "cf2d3fabb0577e6225d75e63131b2347987f81f6"
  end

  # Keep log folders
  skip_clean 'libexec'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install %w{ NOTICE LICENSE RELEASE-NOTES RUNNING.txt }
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/'fulldocs').install resource('fulldocs') if build.with? 'fulldocs'
  end
end
