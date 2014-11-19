require 'formula'

class Kawa < Formula
  homepage 'http://www.gnu.org/software/kawa/'
  url 'http://ftpmirror.gnu.org/kawa/kawa-1.14.jar'
  mirror 'http://ftp.gnu.org/gnu/kawa/kawa-1.14.jar'
  sha1 '87354829bfb28649c771d011769cf79fac5b2621'

  devel do
    url 'http://ftpmirror.gnu.org/kawa/kawa-1.90.jar'
    mirror 'http://ftp.gnu.org/gnu/kawa/kawa-1.90.jar'
    sha1 '19f63dd5f4a170fbd94e37908edc5e85fa365c44'
  end

  def install
    prefix.install "kawa-#{version}.jar"
    (bin+'kawa').write <<-EOS.undent
      #!/bin/sh
      KAWA_HOME="#{prefix}"
      java -jar "$KAWA_HOME/kawa-#{version}.jar"
    EOS
  end
end
