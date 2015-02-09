require 'formula'

class Hive < Formula
  homepage 'http://hive.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=hive/hive-1.0.0/apache-hive-1.0.0-bin.tar.gz'
  sha1 '8e24c451ebab1333352a2f0407d5fe847759fbd2'

  depends_on 'hadoop'
  conflicts_with 'apache-spark', :because => 'both install `beeline` binaries'

  def install
    rm_f Dir["bin/ext/*.cmd", "bin/ext/util/*.cmd"]
    libexec.install %w[bin conf examples hcatalog lib scripts]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Hadoop must be in your path for hive executable to work.
    After installation, set $HIVE_HOME in your profile:
      export HIVE_HOME=#{libexec}

    If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
      export HCAT_HOME=#{libexec}/hcatalog

    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end
end
