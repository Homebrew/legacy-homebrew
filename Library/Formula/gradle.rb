require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-6'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-6-bin.zip'
  md5 '85b6c8662b71c7033ce359912f241616'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
