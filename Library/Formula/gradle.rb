require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://downloads.gradle.org/distributions/gradle-2.1-bin.zip'
  sha1 'b8fa88f4053452b0b09f159b8668ce08e4dc5fa8'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
