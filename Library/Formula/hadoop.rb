require 'formula'

class Hadoop < Formula
  homepage 'http://hadoop.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-2.2.0/hadoop-2.2.0.tar.gz'
  sha1 '7339da348d9b4a813b1b1d8b6982f3f8755329e4'

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
    # But don't make rcc visible, it conflicts with Qt
    (bin/'rcc').unlink

    inreplace "#{libexec}/etc/hadoop/hadoop-env.sh",
      "export JAVA_HOME=${JAVA_HOME}",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    inreplace "#{libexec}/etc/hadoop/yarn-env.sh",
      "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    inreplace "#{libexec}/etc/hadoop/mapred-env.sh",
      "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/etc/hadoop/hadoop-env.sh,
      #{libexec}/etc/hadoop/mapred-env.sh and
      #{libexec}/etc/hadoop/yarn-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    EOS
  end
end
