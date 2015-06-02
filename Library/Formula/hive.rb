require 'formula'

class Hive < Formula
  homepage 'https://hive.apache.org'
  url 'https://www.apache.org/dyn/closer.cgi?path=hive/hive-1.1.1/apache-hive-1.1.1-bin.tar.gz'
  sha1 '23af1918248aa441a010f57d9589a968d00de8fe'

  depends_on 'hadoop'
  depends_on :java

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
