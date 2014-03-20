require 'formula'

class Maven < Formula
  homepage 'http://maven.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz'
  sha1 '40e1bf0775fd3ebcac1dbeb61153b871b86b894f'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, 'conf/settings.xml'

    prefix.install_metafiles
    libexec.install Dir['*']

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    bin.install_symlink Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/m2.conf"]
  end

  test do
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
