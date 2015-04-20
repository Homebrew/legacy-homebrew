require 'formula'

class Sqoop < Formula
  homepage 'http://sqoop.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=sqoop/1.4.5/sqoop-1.4.5.bin__hadoop-2.0.4-alpha.tar.gz'
  version '1.4.5'
  sha1 'cb1831d0da2b6f508f62b144d405d859e371e111'

  depends_on 'hadoop'
  depends_on 'hbase'
  depends_on 'hive'
  depends_on 'zookeeper'

  def spoop_envs
    <<-EOS.undent
      export HADOOP_HOME="#{HOMEBREW_PREFIX}"
      export HBASE_HOME="#{HOMEBREW_PREFIX}"
      export HIVE_HOME="#{HOMEBREW_PREFIX}"
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    libexec.install Dir['*.jar']
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    # Install a sqoop-env.sh file
    envs = libexec/'conf/sqoop-env.sh'
    envs.write(spoop_envs) unless envs.exist?
  end

  def caveats; <<-EOS.undent
    Hadoop, Hive, HBase and ZooKeeper must be installed and configured
    for Sqoop to work.
    EOS
  end
end
