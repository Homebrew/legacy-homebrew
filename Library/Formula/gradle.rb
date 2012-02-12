require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://repo.gradle.org/gradle/distributions/gradle-1.0-milestone-7-bin.zip'
  version '1.0-milestone-7'
  md5 '3622dbf2f2ef30c5abf5d8b94e709e13'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
