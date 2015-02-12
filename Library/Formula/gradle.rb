require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-2.2.1-bin.zip'
  sha1 '97ae081bc8be8b691e21dcf792eff1630dbc8eb6'

  devel do
    url 'https://services.gradle.org/distributions/gradle-2.3-rc-4-bin.zip'
    sha1 '0c501c06a4069a52f1afe2515540d1d76221596b'
    version '2.3-rc-4'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
