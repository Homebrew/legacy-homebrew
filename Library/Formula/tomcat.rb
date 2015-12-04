class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.29/bin/apache-tomcat-8.0.29.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.29/bin/apache-tomcat-8.0.29.tar.gz"
    sha256 "5fdb315918f3c635258f25d412c6c89869162fcd3ee7161291d484e72076e9d0"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.29/bin/apache-tomcat-8.0.29-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.29/bin/apache-tomcat-8.0.29-fulldocs.tar.gz"
      version "8.0.29"
      sha256 "5453eec4bfd94f254f9d06a759794e723e6a77a1f3f4dde73691bad0b8c91409"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M1/bin/apache-tomcat-9.0.0.M1.tar.gz"
    version "9.0.0.M1"
    sha256 "5e06b82709dba9a1314957f164f270f0edb2e94b7df9ad002ca50fbc881d512f"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M1/bin/apache-tomcat-9.0.0.M1-fulldocs.tar.gz"
      version "9.0.0.M1"
      sha256 "7a23854526968793c423e7afac1329b0268aa85e5ccbaefeb411d7749bcc090e"
    end
  end

  bottle :unneeded

  option "with-fulldocs", "Install full documentation locally"

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
