require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.0-rc-3-bin.zip'
  md5 '1a32e467930c05b3dca56a9543634511'
  version '1.0-rc-3'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
