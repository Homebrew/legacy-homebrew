require 'formula'

class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage 'http://www.gnu.org/software/kawa/'
  url 'http://ftpmirror.gnu.org/kawa/kawa-2.0.jar'
  mirror 'http://ftp.gnu.org/gnu/kawa/kawa-2.0.jar'
  sha1 '150dacc0b1dbf55c5493da022a590d9d8549b3b6'

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
      #!/bin/sh
      KAWA_HOME="#{prefix}"
      java -jar "$KAWA_HOME/kawa-#{version}.jar"
    EOS
  end
end
