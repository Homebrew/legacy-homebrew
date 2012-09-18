require 'formula'

class Proguard < Formula
  homepage 'http://proguard.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/proguard/proguard/4.8/proguard4.8.tar.gz'
  sha256 '84db4aef4235ad312e221ae95485d7848fc468db66699f1b155d89c5036374f6'

  def install
    libexec.install 'lib/proguard.jar'
    (bin+"proguard").write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/proguard.jar" "$@"
    EOS
  end
end
