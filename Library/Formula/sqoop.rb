require 'formula'

class Sqoop < Formula
  homepage 'http://sqoop.apache.org/'
  url 'http://apache.mirror.iphh.net/sqoop/1.4.2/sqoop-1.4.2.bin__hadoop-1.0.0.tar.gz'
  version '1.4.2'
  sha1 'c028a4d34a83b9c6ae4919bf1e44cb1d138f14c6'

  depends_on 'hadoop'
  depends_on 'hbase'
  depends_on 'hive'
  depends_on 'zookeeper'

  def install
    libexec.install %w[bin conf lib]
    libexec.install Dir['*.jar']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Hadoop, Hive, HBase and ZooKeeper must be installed for
    Sqoop to work.
    After installation, set the appropriate paths in:
      #{libexec}/conf/sqoop-env.sh
    EOS
  end
end
