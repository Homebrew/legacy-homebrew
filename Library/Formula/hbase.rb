class Hbase < Formula
  homepage "http://hbase.apache.org"
  url "http://www.apache.org/dyn/closer.cgi?path=hbase/hbase-1.0.1/hbase-1.0.1-bin.tar.gz"
  sha1 "ef5948d47b8c2e4a4360a1e18008aab7ae1cf88c"

  depends_on :java => "1.6+"
  depends_on "hadoop"

  def install
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf docs lib hbase-webapps]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    inreplace "#{libexec}/conf/hbase-env.sh",
      "# export JAVA_HOME=/usr/java/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    You must edit the configs in:
      #{libexec}/conf
    to reflect your environment.

    For more details:
      http://wiki.apache.org/hadoop/Hbase
    EOS
  end
end
