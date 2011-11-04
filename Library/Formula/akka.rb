require 'formula'

class Akka < Formula
  url 'http://akka.io/downloads/akka-microkernel-1.2.zip'
  homepage 'http://akka.io/'
  md5 '813a50175225bacdda0476ca014c5523'
  version '1.2.0'

  depends_on 'scala'

  def install
    # Translate akka script
    script = ::File.read("bin/akka")
    script.gsub!(/^AKKA_HOME=.*$/, "AKKA_HOME=#{prefix}")
    script.gsub!(/\$AKKA_HOME\/lib\//, "$AKKA_HOME/libexec/")

    rm "bin/akka"
    rm "bin/akka.bat"

    ::File.open('bin/akka', 'w') do |f|
      f.puts script
    end

    mv "lib", "libexec"
    prefix.install Dir["*"]
  end
end
