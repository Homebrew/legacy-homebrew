require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.0-milestone-8a-bin.zip'
  md5 '7c0bfa1b25ea523f748a4217a1e47f5b'
  version '1.0-milestone-8a'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
