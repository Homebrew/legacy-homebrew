require 'formula'

class Gradle <Formula
  homepage 'http://www.gradle.org/'
  version '0.9.2'
  url 'http://gradle.artifactoryonline.com/gradle/distributions/gradle-0.9.2-all.zip'
  md5 '8574a445267ce3ad21558e300d854d24'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end