require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.7-bin.zip'
  sha1 '0cbadad3ced2ba5c53bbb7e6ec3e779c1cd3966c'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.8-rc-1-bin.zip'
    sha1 'd43e0d53f054549dc84ccc95f1e7e9460d07472e'
    version '1.8-rc1'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
