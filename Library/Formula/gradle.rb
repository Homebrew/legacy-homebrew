require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://downloads.gradle.org/distributions/gradle-2.3-bin.zip'
  sha1 'db857319150aa8f90cfcc1df7991c0ef4bcd180a'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
