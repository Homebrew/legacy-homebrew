class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hbase/1.1.2/hbase-1.1.2-bin.tar.gz"
  sha256 "8ca5bf0203cef86b4a0acbba89afcd5977488ebc73eec097e93c592b16f8bede"

  bottle :unneeded

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
      https://hbase.apache.org/book.html
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/hbase mapredcp")
  end
end
