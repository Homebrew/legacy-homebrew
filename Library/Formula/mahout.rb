require 'formula'

class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage 'https://mahout.apache.org/'
  url 'https://www.apache.org/dyn/closer.cgi?path=mahout/0.10.0/mahout-distribution-0.10.0.tar.gz'
  sha1 'c8dcb51a04eb026eb9fd0fe6cb496cb101cf632d'

  head do
    url 'https://svn.apache.org/repos/asf/mahout/trunk'
    depends_on 'maven' => :build
  end

  depends_on 'hadoop'
  depends_on :java

  def install
    if build.head?
      chmod 755, './bin'
      system 'mvn -DskipTests clean install'
    end

    libexec.install "bin"

    if build.head?
      libexec.install Dir['buildtools/target/*.jar']
      libexec.install Dir['core/target/*.jar']
      libexec.install Dir['examples/target/*.jar']
      libexec.install Dir['math/target/*.jar']
    else
      libexec.install Dir['*.jar']
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Mahout requires JAVA_HOME to be set:
      export JAVA_HOME=$(/usr/libexec/java_home)
    EOS
  end
end
