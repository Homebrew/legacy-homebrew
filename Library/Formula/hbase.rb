require 'formula'

class Hbase < Formula
  url 'http://www.gtlib.gatech.edu/pub/apache//hbase/hbase-0.90.1/hbase-0.90.1.tar.gz'
  homepage 'http://hbase.apache.org'
  md5 'dbf090fcb12a47c0b6c713c3caa7b1fd'

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
