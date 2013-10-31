require 'formula'

class Mahout < Formula
  homepage 'http://mahout.apache.org/'
  head 'http://svn.apache.org/repos/asf/mahout/trunk'
  url 'http://apache.cs.utah.edu/mahout/0.8/mahout-distribution-0.8.tar.gz'
  sha1 '666fe711603670c316c4c9f4f5580a9d0caf2dff'
  depends_on 'maven' => :build
  depends_on 'hadoop'

  bottle do
    sha1 '9dea60acc861eaacb31e980c4be01616f4761f44' => :mavericks
  end

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec #{libexec}/bin/#{target} $@
    EOS
  end

  def install
    system 'chmod 755 ./bin'
    system 'mvn -DskipTests clean install'
    libexec.install %w[bin]
    libexec.install Dir['buildtools/target/*.jar']
    libexec.install Dir['core/target/*.jar']
    libexec.install Dir['examples/target/*.jar']
    libexec.install Dir['math/target/*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end

  def caveats; <<-EOS.undent
    Mahout requires JAVA_HOME to be set:
      export JAVA_HOME=$(/usr/libexec/java_home)
    EOS
  end
end
