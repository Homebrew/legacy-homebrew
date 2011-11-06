require 'formula'

class Hive < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=hive/hive-0.7.1/hive-0.7.1-bin.tar.gz'
  homepage 'http://hive.apache.org'
  md5 '5fb37e7ea3526e50185c1d7edda0f789'

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
