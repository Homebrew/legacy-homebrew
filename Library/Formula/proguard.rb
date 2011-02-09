require 'formula'

class Proguard <Formula
  url 'http://heanet.dl.sourceforge.net/project/proguard/proguard%20beta/4.6beta/proguard4.6beta3.tar.gz'
  homepage 'http://proguard.sourceforge.net/'
  md5 'ec9fb40f560cc79dbe6768c2abdd681d'
  version '4.6beta3'

  def install
    libexec.install ['lib/proguard.jar']
    (bin/:proguard).write <<-EOS.undent
      #!/bin/sh
      java -jar #{libexec}/proguard.jar $*
    EOS
  end
end
