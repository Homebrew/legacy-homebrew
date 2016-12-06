require 'formula'

class HadoopCdh3u3 < Formula
  homepage 'https://ccp.cloudera.com/display/SUPPORT/CDH3+Downloadable+Tarballs'
  url 'http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u3.tar.gz'
  md5 'bec38b1d8821a034d79cadb0e568d60c'

  version '0.20.2-cdh3u3'

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
