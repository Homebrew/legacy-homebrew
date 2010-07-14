require 'formula'

class Hadoop < Formula
  url 'http://www.carfab.com/apachesoftware/hadoop/core/hadoop-0.20.2/hadoop-0.20.2.tar.gz'
  homepage 'http://hadoop.apache.org/common/'
  md5 '8f40198ed18bef28aeea1401ec536cb9'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec}/bin
      ./#{target} $*
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf contrib lib]
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end

  def caveats
    <<-EOS.undent
      $JAVA_HOME must be set for Hadoop commands to work.
    EOS
  end
end
