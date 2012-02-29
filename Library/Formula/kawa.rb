require 'formula'

class Kawa < Formula
  url 'http://ftpmirror.gnu.org/kawa/kawa-1.11.jar'
  mirror 'http://ftp.gnu.org/gnu/kawa/kawa-1.11.jar'
  homepage 'http://www.gnu.org/software/kawa/'
  md5 'eee96e13a329513a2f705ee03bacef63'

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
      #!/bin/sh
      KAWA_HOME="#{prefix}"
      java -jar "$KAWA_HOME/kawa-#{version}.jar"
    EOS
  end
end
