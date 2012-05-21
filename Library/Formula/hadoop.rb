require 'formula'

class Hadoop < Formula
  homepage 'http://hadoop.apache.org/common/'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-1.0.3/hadoop-1.0.3.tar.gz'
  md5 'f42d05e5c7bb43f85119546b80296435'

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib webapps contrib]
    libexec.install Dir['*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end

    inreplace "#{libexec}/conf/hadoop-env.sh",
      "# export JAVA_HOME=/usr/lib/j2sdk1.5-sun",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/conf/hadoop-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    EOS
  end
end
