require 'formula'

class Xmlsh < Formula
  homepage 'http://www.xmlsh.org'
  url 'https://downloads.sourceforge.net/project/xmlsh/xmlsh/1.2.4/xmlsh_1_2_4.zip'
  sha1 'ef11e6fa3d72d99b78331a4ab58a22b1ad08b4ef'

  def install
    rm_rf %w[win32 cygwin]
    libexec.install Dir["*"]
    chmod 0755, "#{libexec}/unix/xmlsh"
    (bin/"xmlsh").write <<-EOS.undent
      #!/bin/bash
      export XMLSH=#{libexec}
      exec #{libexec}/unix/xmlsh "$@"
    EOS
  end
end
