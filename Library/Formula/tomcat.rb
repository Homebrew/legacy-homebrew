class Tomcat < Formula
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21.tar.gz"
  sha1 "957e88df8a9c3fc6b786321c4014b44c5c775773"

  bottle do
    cellar :any
    sha1 "2315d52b6a3dd5f178d02da6b84c67189d333cb1" => :yosemite
    sha1 "63ac2a7f329f3620ea0505053dc90e25443c02f6" => :mavericks
    sha1 "e5abae0c006059d41d9465776946f8ee8970aa9d" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21-fulldocs.tar.gz"
    version "8.0.21"
    sha1 "3fc4db49c36846b4197810b7f26d07f5bdd17931"
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
