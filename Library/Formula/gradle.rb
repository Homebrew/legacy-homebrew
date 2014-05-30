require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-1.12-bin.zip'
  sha1 '4fee5af4ce5c1214bdbd5e14ef6adda9929f589f'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
