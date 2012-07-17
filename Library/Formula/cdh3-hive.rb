require 'formula'

class Cdh3Hive < Formula
  homepage 'https://ccp.cloudera.com/display/CDHDOC/CDH3+Release+Notes'
  url 'http://archive.cloudera.com/cdh/3/hive-0.7.1-cdh3u4.tar.gz'
  md5 '16a4771a1fc95262f93ca50683cac011'

  depends_on 'cdh3-hadoop'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.mkpath
    libexec.install %w[bin conf examples lib scripts ]
    libexec.install Dir['*.jar']
    bin.mkpath

    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end

  def caveats; <<-EOS.undent
    Hadoop must be in your path for hive executable to work.
    After installation, set $HIVE_HOME in your profile:
      export HIVE_HOME=#{libexec}

    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end
end
