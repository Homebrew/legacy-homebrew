require 'formula'

class Hive < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/hive/hive-0.5.0/hive-0.5.0-bin.tar.gz'
  homepage 'http://hive.apache.org'
  md5 '2d3b47ceaea6d5cdeaabc544aa9c2c28'

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

    You may also need to set JAVA_HOME.
    EOS
  end
end
