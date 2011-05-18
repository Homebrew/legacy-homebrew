require 'formula'

class Sonar < Formula
  url 'http://dist.sonar.codehaus.org/sonar-2.13.1.zip'
  homepage 'http://www.sonarsource.org'
  md5 '37e0502e07e197b8e3a382c64fac8e1d'

  def install
    # Delete bin directories
    rm_rf Dir['bin/aix-*']
    rm_rf Dir['bin/hpux-*']
    rm_rf Dir['bin/linux-*']
    rm_rf Dir['bin/solaris-*']
    rm_rf Dir['bin/windows-*']

    if Hardware.is_32_bit?
      rm_rf Dir['bin/macosx-universal-64']
    else 
      rm_rf Dir['bin/macosx-universal-32']
    end

    # Delete bat files
    rm_f Dir['war/*.bat']
    
    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath

    if Hardware.is_32_bit?
      ln_s "#{libexec}/bin/macosx-universal-32/sonar.sh", bin+"sonar"
    else 
      ln_s "#{libexec}/bin/macosx-universal-64/sonar.sh", bin+"sonar"
    end
  end
end
