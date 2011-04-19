require 'formula'

class Hbase < Formula
  url 'http://www.takeyellow.com/apachemirror//hbase/hbase-0.90.2/hbase-0.90.2.tar.gz'
  homepage 'http://hbase.apache.org'
  md5 '83f12e3a1d32375d1e2caa6245cda3d8'

  depends_on 'hadoop'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{target} $@
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf docs lib hbase-webapps]
    libexec.install Dir['*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    inreplace "#{libexec}/conf/hbase-env.sh",
      "# export JAVA_HOME=/usr/java/jdk1.6.0/",
      "export JAVA_HOME=$(/usr/libexec/java_home)"
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
