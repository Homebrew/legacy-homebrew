require 'formula'

class Hive < Formula
  homepage 'http://hive.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=hive/hive-0.12.0/hive-0.12.0-bin.tar.gz'
  sha1 '4fee5cb46ef421c768553965b9f086c6a975eb47'

  depends_on 'hadoop'
  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf examples lib ]
    libexec.install Dir['*.jar']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
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
