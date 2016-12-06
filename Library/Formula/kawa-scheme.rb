require 'formula'

class KawaScheme < Formula
  url 'ftp://ftp.gnu.org/pub/gnu/kawa/kawa-1.8.jar'
  homepage 'http://www.gnu.org/software/kawa/'
  md5 '401ecedd153384a103a959364a927a22'

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
    #!/bin/sh
    KAWA_HOME=#{prefix}
    java -jar $KAWA_HOME/kawa-#{version}.jar
    EOS
  end

end
