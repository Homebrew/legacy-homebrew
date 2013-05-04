require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.5-bin.zip'
  sha1 '092df1cec7e813bc9e09c016eef7c91ddfde824c'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
