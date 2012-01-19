require 'formula'

class Proguard < Formula
  url 'http://downloads.sourceforge.net/project/proguard/proguard/4.7/proguard4.7.tar.gz'
  homepage 'http://proguard.sourceforge.net/'
  md5 '7c3e746308c0385f09783c3ee710fcc4'

  def install
    libexec.install ['lib/proguard.jar']
    (bin/:proguard).write <<-EOS.undent
      #!/bin/sh
      java -jar #{libexec}/proguard.jar $*
    EOS
  end
end
