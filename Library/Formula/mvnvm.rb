require "formula"

class Mvnvm < Formula
  homepage "http://mvnvm.org"
  url "https://bitbucket.org/mjensen/mvnvm/get/0d4318ea71a2.zip"
  version "0.0.1-20141113"
  sha1 "9a6840ded35ce30bc58a573ea3757e5b2977c27d"

  def install
    bin.install "mvn"
  end

  conflicts_with 'maven',
    :because => 'instead of installing Maven via Homebrew, you should use mvnvm to manage your Maven versions.'

  test do
    (testpath/'mvnvm.properties').write <<-EOS.undent
      mvn_version=3.0.5
    EOS
    (testpath/'pom.xml').write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        
      </project>
    EOS
    (testpath/'src/main/java/org/homebrew/MavenTest.java').write <<-EOS.undent
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", 'compile'
  end
end
