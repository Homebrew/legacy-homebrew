require 'formula'

class Mahout < Formula
  head 'http://svn.apache.org/repos/asf/mahout/trunk'
  homepage 'http://mahout.apache.org/'
  md5 ''

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec #{libexec}/bin/#{target} $@
    EOS
  end

  def install
    system "mvn install -DskipTests=true"
    libexec.install %w[bin taste-web]
    libexec.install Dir['core/target/*.jar']
    libexec.install Dir['buildtools/target/*.jar']
    libexec.install Dir['eclipse/target/*.jar']
    libexec.install Dir['examples/target/*.jar']
    libexec.install Dir['math/target/*.jar']
    libexec.install Dir['utils/target/*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    #  "# export JAVA_HOME=/usr/lib/j2sdk1.6-sun",
    #  "export JAVA_HOME=$(/usr/libexec/java_home)"
  end

  def caveats; <<-EOS.undent
    Mahout requires JAVA_HOME and HADOOP_HOME to be set:
      export JAVA_HOME=$(/usr/libexec/java_home)
      export HADOOP_HOME=#{HOMEBREW_PREFIX}/Cellar/hadoop/0.20.2/

    Please note that you need to install Hadoop 0.20.2 and not 0.21.0:
      sed -i "" s/0.21.0/0.20.2/g #{HOMEBREW_PREFIX}/Library/Formula/hadoop.rb
      sed -i "" s/ec0f791f866f82a7f2c1319a54f4db97/8f40198ed18bef28aeea1401ec536cb9/g #{HOMEBREW_PREFIX}/Library/Formula/hadoop.rb
      brew install hadoop
    EOS
  end
end
