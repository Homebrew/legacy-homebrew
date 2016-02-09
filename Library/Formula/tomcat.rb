class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz"
    mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz"
    sha256 "7e23260f2481aca88f89838e91cb9ff00548a28ba5a19a88ff99388c7ee9a9b8"

    depends_on :java => "1.7+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32-fulldocs.tar.gz"
      mirror "https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32-fulldocs.tar.gz"
      version "8.0.32"
      sha256 "b3a13d3c4a5de2970b8097117e2b8976c2a42d0fdb8492c116533e6e59a1c305"
    end
  end

  devel do
    url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M3/bin/apache-tomcat-9.0.0.M3.tar.gz"
    version "9.0.0.M3"
    sha256 "edde79fdd49649ffc2ce6b8c7a6b665b45a450629b60e78f436f3528570e9104"

    depends_on :java => "1.8+"

    resource "fulldocs" do
      url "https://www.apache.org/dyn/closer.cgi?path=/tomcat/tomcat-9/v9.0.0.M3/bin/apache-tomcat-9.0.0.M3-fulldocs.tar.gz"
      version "9.0.0.M3"
      sha256 "c430d0044823857099601d82afe0f15e715859dc17402f9ce7083d0647f63e9b"
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

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    File.exist? testpath/"logs/catalina.out"
  end
end
