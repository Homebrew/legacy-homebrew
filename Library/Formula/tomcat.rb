class Tomcat < Formula
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22.tar.gz"
  sha256 "cb163576d03f45981bf025b62b46e71c3c634584daa4662fc721d37d46989eff"

  bottle do
    cellar :any
    sha256 "00f059d92cb53b70e89f710bd3836318d2b8b60c49ac1a1fc03d1c93347d2c16" => :yosemite
    sha256 "eccf010c1c89fd74905f8f2df8c5fa489464b8c7d8239d2823a27a9f2b7cc58a" => :mavericks
    sha256 "4e2db444d69c635bf6b575ba6442183c0013f323d4aa5178591d3a770e43ccc0" => :mountain_lion
  end

  option "with-fulldocs", "Install full documentation locally"

  resource "fulldocs" do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22-fulldocs.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22-fulldocs.tar.gz"
    version "8.0.22"
    sha256 "f1287f7a005180d8ff8b60461327554c9d5473d1d6784d97cbb4b580ef292c8c"
  end

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[ NOTICE LICENSE RELEASE-NOTES RUNNING.txt ]
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/catalina.sh" => "catalina"

    (share/"fulldocs").install resource("fulldocs") if build.with? "fulldocs"
  end
end
