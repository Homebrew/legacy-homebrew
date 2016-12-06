require 'formula'

class Accumulo < Formula
  homepage 'http://accumulo.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=/accumulo/1.4.2/accumulo-1.4.2-dist.tar.gz'
  sha1 '967863c849785f37a89fcbd7e12e50068586dee8'

  depends_on 'hadoop'
  depends_on 'zookeeper'

  def install
    libexec.install %w[bin conf contrib docs lib src test]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    cp Dir.glob("#{libexec}/conf/examples/512MB/standalone/*"), "#{libexec}/conf"
    mv "#{bin}/start-all.sh", "#{bin}/accumulo-start-all.sh"
    mv "#{bin}/stop-all.sh", "#{bin}/accumulo-stop-all.sh"

    inreplace "#{libexec}/conf/accumulo-env.sh",
      "/path/to/java",
      "\"$(/usr/libexec/java_home)\""

    inreplace "#{libexec}/conf/accumulo-env.sh",
      "/path/to/hadoop",
      "#{HOMEBREW_PREFIX}/opt/hadoop/libexec"

    inreplace "#{libexec}/conf/accumulo-env.sh",
      "/path/to/zookeeper",
      "#{HOMEBREW_PREFIX}/opt/zookeeper/libexec"
  end

  def caveats; <<-EOS.undent
    In Accumulo's config file:
      #{libexec}/conf/accumulo-env.sh
    JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    HADOOP_HOME has been set to #{HOMEBREW_PREFIX}/opt/hadoop/libexec
    ZOOKEEPER_HOME has been set to #{HOMEBREW_PREFIX}/opt/zookeeper/libexec

    You must have Hadoop and Zookeeper configured and running prior to starting
    Accumulo. Per standard installation procedures you must also run bin/accumulo
    init to initialize Accumulo prior to starting it. accumulo-start-all.sh should
    have been installed in your PATH for convenience.
    EOS
  end

 end
