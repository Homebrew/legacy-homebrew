require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-3'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-3-all.zip'
  md5 'e3e01c894da324654da044089e6842ea'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
