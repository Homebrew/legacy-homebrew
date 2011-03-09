require 'formula'

class Gradle <Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-1'
  url 'http://gradle.artifactoryonline.com/gradle/distributions/gradle-1.0-milestone-1-all.zip'
  md5 '8bea9ef3293e1aff1d26dd2a7e44e08a'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end