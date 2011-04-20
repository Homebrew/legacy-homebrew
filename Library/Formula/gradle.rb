require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  version '1.0-milestone-2'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-2-all.zip'
  md5 '7d3184d952e4f8fc2d650c1fe77ff06e'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.mkpath
    ln_s libexec+('bin/gradle'), bin
  end
end
