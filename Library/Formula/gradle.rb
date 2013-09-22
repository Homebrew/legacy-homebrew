require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.7-bin.zip'
  sha1 '0cbadad3ced2ba5c53bbb7e6ec3e779c1cd3966c'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.8-rc-2-bin.zip'
    sha1 '85c048ecf773560e9a6032ed845f225098a4da43'
    version '1.8-rc2'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
