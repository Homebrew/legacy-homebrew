require 'formula'

class Akka < Formula
  url 'http://akka.io/downloads/akka-microkernel-1.2.zip'
  homepage 'http://akka.io/'
  md5 '813a50175225bacdda0476ca014c5523'
  version '1.2.0'

  depends_on 'scala'

  def install
    # Translate akka script
    inreplace "bin/akka", /^AKKA_HOME=.*$/, "AKKA_HOME=#{prefix}"
    inreplace "bin/akka", /\$AKKA_HOME\/lib\//, "$AKKA_HOME/libexec/"

    # Remove Windows bat file - unnecessary
    rm "bin/akka.bat"

    # Move JAR files to libexec
    mv "lib", "libexec"

    # install into prefix directory
    prefix.install Dir["*"]
  end
end
