require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.7-bin.zip'
  sha1 '0cbadad3ced2ba5c53bbb7e6ec3e779c1cd3966c'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
