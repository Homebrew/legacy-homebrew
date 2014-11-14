require "formula"

class Mvnvm < Formula
  homepage "http://mvnvm.org"
  url "https://bitbucket.org/mjensen/mvnvm/get/mvnvm-0.1.zip"
  sha1 "8e6f07f0395eeca400bb676114b6e2dc6d829a82"

  depends_on :java => "1.7"
  head do
    url "https://bitbucket.org/mjensen/mvnvm/get/master.zip"
  end

  def install
    bin.install "mvn"
  end

  conflicts_with "maven",
    :because => "instead of installing Maven via Homebrew, you should use mvnvm to manage your Maven versions."

  def caveats; <<-EOS.undent
    You may need to set JAVA_HOME for maven:
      export JAVA_HOME=$(/usr/libexec/java_home)
    EOS
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    (testpath/"mvnvm.properties").write <<-EOS.undent
      mvn_version=3.0.5
    EOS
    (testpath/"pom.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<-EOS.undent
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "compile"
  end
end
