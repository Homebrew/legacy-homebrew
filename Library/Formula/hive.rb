require 'formula'

class Hive <Formula
  url 'http://www.bizdirusa.com/mirrors/apache/hadoop/hive/hive-0.5.0/hive-0.5.0-bin.tar.gz'
  homepage 'http://hive.apache.org'
  version '0.5.0'
  md5 'f7b7c2c51bdaca813d0bb60c691f532d'

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
    Hadoop must be in your path for hive executable to work
    After installation, set $HIVE_HOME in your profile
    EOS
  end

end
