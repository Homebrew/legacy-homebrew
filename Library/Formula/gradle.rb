require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-4'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-4-all.zip'
  md5 'f576fe1b165facd67b5647020031ad83'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
