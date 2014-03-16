require 'formula'

class Hbase < Formula
  homepage 'http://hbase.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=hbase/hbase-0.94.16/hbase-0.94.16.tar.gz'
  sha1 '32dd12ccf9ae46ec38e31b5a08900a0c576c874a'

  devel do
    url 'http://www.apache.org/dyn/closer.cgi?path=hbase/hbase-0.96.1.1/hbase-0.96.1.1-hadoop1-bin.tar.gz'
    sha1 'b0aba57e9b5a797ec2f9208457d4b02bbbecbb5a'
  end

  depends_on 'hadoop'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf docs lib hbase-webapps]
    libexec.install Dir['*.jar']
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    inreplace "#{libexec}/conf/hbase-env.sh",
      "# export JAVA_HOME=/usr/java/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    Requires Java 1.6.0 or greater.

    You must also edit the configs in:
      #{libexec}/conf
    to reflect your environment.

    For more details:
      http://wiki.apache.org/hadoop/Hbase
    EOS
  end
end
