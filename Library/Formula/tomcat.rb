class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz"
    sha256 "a7a6c092b79fc5a8cffe5916d0e5554254eddcb3c1911ed90696c153b4f13d10"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28-fulldocs.tar.gz"
      version "8.0.28"
      sha256 "be503ea13eac5ca06bd028d1f768c5c935b060ac0a320cd9788408f2f2faa61f"
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
