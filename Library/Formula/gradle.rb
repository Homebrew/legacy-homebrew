require 'formula'

class Gradle <Formula
  homepage 'http://www.gradle.org/'
  version '0.9.1'
  url 'http://gradle.artifactoryonline.com/gradle/distributions/gradle-0.9.1-all.zip'
  md5 '8fa0acfbcdf01a8425c1f797f5079e21'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end