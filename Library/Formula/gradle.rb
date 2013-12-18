require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.10-bin.zip'
  sha1 'f911beeff25ebbb7b4af3092dd7f0c93019aef17'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
