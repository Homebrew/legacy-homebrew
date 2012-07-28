require 'formula'

class Kawa < Formula
  url 'http://ftpmirror.gnu.org/kawa/kawa-1.12.jar'
  mirror 'http://ftp.gnu.org/gnu/kawa/kawa-1.12.jar'
  homepage 'http://www.gnu.org/software/kawa/'
  sha1 '7b682781704ca052825ad83ed93261d9fdca16ce'

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
      #!/bin/sh
      KAWA_HOME="#{prefix}"
      java -jar "$KAWA_HOME/kawa-#{version}.jar"
    EOS
  end
end
