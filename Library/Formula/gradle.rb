require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://downloads.gradle.org/distributions/gradle-2.2-bin.zip'
  sha1 '9e0f1d3e962dd7a38dbf17bace183a78423dbe4a'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
