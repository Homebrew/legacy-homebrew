require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.0-milestone-8-bin.zip'
  version '1.0-milestone-8'
  md5 '29400a0f16defd5d2e19581b811a1228'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
