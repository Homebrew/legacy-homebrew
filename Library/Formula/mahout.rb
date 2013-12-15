require 'formula'

class Mahout < Formula
  homepage 'http://mahout.apache.org/'
  head 'http://svn.apache.org/repos/asf/mahout/trunk'
  url 'http://apache.cs.utah.edu/mahout/0.8/mahout-distribution-0.8.tar.gz'
  sha1 '67669fa4a8969a8b8c6ebb94fa7f5aeae96e9119'

  depends_on 'maven' => :build
  depends_on 'hadoop'

  def install
    if build.head?
      system 'chmod 755 ./bin'
      system 'mvn -DskipTests clean install'
    end

    libexec.install %w[bin]

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
