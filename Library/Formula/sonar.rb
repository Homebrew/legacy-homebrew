require 'formula'

class Sonar < Formula
  homepage 'http://www.sonarsource.org'
  url 'http://dist.sonar.codehaus.org/sonar-2.13.1.zip'
  md5 '37e0502e07e197b8e3a382c64fac8e1d'

  def install
    # Delete native bin directories for other systems
    rm_rf Dir['bin/{aix,hpux,linux,solaris,windows}-*']

    if MacOS.prefer_64_bit?
      rm_rf Dir['bin/macosx-universal-32']
    else
      rm_rf Dir['bin/macosx-universal-64']
    end

    # Delete Windows files
    rm_f Dir['war/*.bat']
    libexec.install Dir['*']

    if MacOS.prefer_64_bit?
      bin.install_symlink "#{libexec}/bin/macosx-universal-64/sonar.sh" => "sonar"
    else
      bin.install_symlink "#{libexec}/bin/macosx-universal-32/sonar.sh" => "sonar"
    end
  end
end
