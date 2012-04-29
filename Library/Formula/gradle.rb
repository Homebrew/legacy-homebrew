require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.0-rc-2-bin.zip'
  md5 '60c5255b0bdc73ae88a1e7ffb9034ecb'
  version '1.0-rc-2'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
