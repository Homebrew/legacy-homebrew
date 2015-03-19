class Tomcat < Formula
  homepage "https://tomcat.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.20/bin/apache-tomcat-8.0.20.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.20/bin/apache-tomcat-8.0.20.tar.gz"
  sha1 "f27e57423a5728216dfe0d38d6f7f4dc03ffee97"

  bottle do
    cellar :any
    sha1 "2315d52b6a3dd5f178d02da6b84c67189d333cb1" => :yosemite
    sha1 "63ac2a7f329f3620ea0505053dc90e25443c02f6" => :mavericks
    sha1 "e5abae0c006059d41d9465776946f8ee8970aa9d" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "http://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.20/bin/apache-tomcat-8.0.20-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.20/bin/apache-tomcat-8.0.20-fulldocs.tar.gz"
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
