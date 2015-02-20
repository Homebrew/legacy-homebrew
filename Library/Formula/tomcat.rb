class Tomcat < Formula
  homepage "http://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.20/bin/apache-tomcat-8.0.20.tar.gz"
  sha1 "f27e57423a5728216dfe0d38d6f7f4dc03ffee97"

  bottle do
    cellar :any
    sha1 "23a9b04f317fae7285a2e2b53a9992baf8c931e3" => :yosemite
    sha1 "8577388903bd4e2295148d5f48a63fa824111dbb" => :mavericks
    sha1 "0c9a206f0e69f75f0b641227747c13d2ac0fda5b" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.20/bin/apache-tomcat-8.0.20-fulldocs.tar.gz"
    version "8.0.20"
    sha1 "7ad70556833a952a084490788d9ea41262a8911c"
  end

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
