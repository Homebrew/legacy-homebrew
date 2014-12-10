require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-2.2.1-bin.zip'
  sha1 '97ae081bc8be8b691e21dcf792eff1630dbc8eb6'

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
