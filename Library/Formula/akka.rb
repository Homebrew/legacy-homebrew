require 'formula'

class Akka < Formula
  url 'http://download.akka.io/downloads/akka-2.0.1.zip'
  homepage 'http://akka.io/'
  md5 '362f9c04176ed89199ae85c6d090ee71'
  version '2.0.1'

  depends_on 'scala'

  def install
    # Translate akka script
    inreplace "bin/akka", /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{prefix}"
    inreplace "bin/akka", /\$AKKA_HOME\/lib\//, "$AKKA_HOME/libexec/"

    # Remove Windows bat file - unnecessary
    rm "bin/akka.bat"

    # Move JAR files to libexec
    mv "lib", "libexec"

    # install into prefix directory
    prefix.install Dir["*"]
  end
end
