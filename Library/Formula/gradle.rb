require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.3-bin.zip'
  sha1 '420815987176f66f51f7f03df73d309a0537a869'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
