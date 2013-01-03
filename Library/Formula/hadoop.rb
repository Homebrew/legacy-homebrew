require 'formula'

class Hadoop < Formula
  homepage 'http://hadoop.apache.org/common/'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-2.0.2-alpha/hadoop-2.0.2-alpha.tar.gz'
  sha1 '44206b2d4b657a8efa47dbe78725c58233e17a9d'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[etc bin sbin lib libexec share]
    libexec.install Dir['*.jar']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    # But don't make rcc visible, it conflicts with Qt
    (bin/'rcc').unlink
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/etc/hadoop/hadoop-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    EOS
  end
end
