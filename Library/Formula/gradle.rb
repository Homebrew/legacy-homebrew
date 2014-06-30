require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-1.12-bin.zip'
  sha1 '4fee5af4ce5c1214bdbd5e14ef6adda9929f589f'

  devel do
    url 'https://services.gradle.org/distributions/gradle-2.0-rc-2-bin.zip'
    sha1 'b424869ea9f123ba1c2573dc431d49dc50c1dd24'
    version '2.0-rc-2'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
