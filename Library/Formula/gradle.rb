require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-5'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-5-bin.zip'
  md5 'd96faf4efcc5b66cf21067e997583379'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
