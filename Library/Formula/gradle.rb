require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-5'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-5-all.zip'
  md5 '2b7eeac68f0d97b1c366080dc77d1658'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
