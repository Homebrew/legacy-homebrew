require 'formula'

class Hive < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=hive/hive-0.8.0/hive-0.8.0-bin.tar.gz'
  homepage 'http://hive.apache.org'
  md5 '9aca92b683da8955aca3beb5a438d2f9'

  depends_on 'hadoop'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf examples lib ]
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
