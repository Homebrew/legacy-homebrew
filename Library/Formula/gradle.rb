require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-2.2.1-bin.zip'
  sha1 '97ae081bc8be8b691e21dcf792eff1630dbc8eb6'

  devel do
    url 'https://services.gradle.org/distributions/gradle-2.3-rc-3-bin.zip'
    sha1 '80f282b2a1d88fa85e955477fbbfb79f86438e12'
    version '2.3-rc-3'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
