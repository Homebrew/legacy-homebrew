require 'formula'

class Proguard < Formula
  url 'http://downloads.sourceforge.net/project/proguard/proguard/4.6/proguard4.6.tar.gz'
  homepage 'http://proguard.sourceforge.net/'
  md5 '4c2f225d996349e3cf705b4aa671a6cb'

  def install
    libexec.install ['lib/proguard.jar']
    (bin/:proguard).write <<-EOS.undent
      #!/bin/sh
      java -jar #{libexec}/proguard.jar $*
    EOS
  end
end
