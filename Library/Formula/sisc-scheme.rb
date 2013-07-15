require 'formula'

class SiscScheme < Formula
  homepage 'http://sisc-scheme.org/'
  url 'http://sourceforge.net/projects/sisc/files/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz'
  sha1 '4572dc584f2a8e82e1a47c49ea5b9d8cf151775d'

  def install
    prefix.install_metafiles
    libexec.install Dir['*']
    (bin/'sisc').write <<-EOS.undent
      #!/bin/sh
      SISC_HOME=#{libexec}
      exec #{libexec}/sisc "$@"
    EOS
  end
end
