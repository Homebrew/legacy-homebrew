require 'formula'

class Gradle <Formula
  homepage 'http://www.gradle.org/'
  version '0.9'
  url 'http://gradle.artifactoryonline.com/gradle/distributions/gradle-0.9-all.zip'
  md5 '9da1eb9fb32d9c303de5fd5568694634'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
