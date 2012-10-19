require 'formula'

class Frege < Formula
  homepage 'http://code.google.com/p/frege/'
  url 'http://frege.googlecode.com/files/frege3.19.112a.jar'
  version '3.19.112a'
  sha1 '882c64832054cdd668c230a4e075477218d72816'

  def install
    libexec.install Dir['*']
    (bin+'fregec').write <<-EOS.undent
      #!/bin/sh
      exec java -Xss1m -jar "#{libexec}/frege3.19.112a.jar" "$@"
    EOS
  end
end
