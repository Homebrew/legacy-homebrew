class Hbase < Formula
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hbase/stable/hbase-1.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/hbase/stable/hbase-1.0.0-bin.tar.gz"
  sha1 "d6886d6c7975ecf312eab745c3642c61f1e753db"

  depends_on :java
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
    Requires Java 1.6.0 or greater.

    You must also edit the configs in:
      #{libexec}/conf
    to reflect your environment.

    For more details:
      https://wiki.apache.org/hadoop/Hbase
    EOS
  end
end
