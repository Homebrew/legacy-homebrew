require 'formula'

class Hive < Formula
  homepage 'http://hive.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=hive/hive-0.13.1/apache-hive-0.13.1-bin.tar.gz'
  sha1 'f9d96e3942ce93a409379f86632e80dd0a75848c'

  depends_on 'hadoop'

  def install
    rm_f Dir["bin/*.bat"]
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
