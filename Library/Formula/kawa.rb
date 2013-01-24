require 'formula'

class Kawa < Formula
  homepage 'http://www.gnu.org/software/kawa/'
  url 'http://ftpmirror.gnu.org/kawa/kawa-1.13.jar'
  mirror 'http://ftp.gnu.org/gnu/kawa/kawa-1.13.jar'
  sha1 'c49155de929d932f48c16e77b318018849deaa78'

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
      #!/bin/sh
      KAWA_HOME="#{prefix}"
      java -jar "$KAWA_HOME/kawa-#{version}.jar"
    EOS
  end
end
