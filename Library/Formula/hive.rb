class Hive < Formula
  desc "Hadoop-based data summarization, query, and analysis"
  homepage "https://hive.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz"
  sha256 "29d9780c4af887ef623bafe6a73ec6f1bea9759bbe31fb4aeeb5b0f68c4c9979"

  bottle :unneeded

  depends_on "hadoop"
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

  test do
    assert_match /default/, shell_output("#{bin}/hive -e 'show databases;'")
  end
end
