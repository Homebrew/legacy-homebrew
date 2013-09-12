require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.7-bin.zip'
  sha1 '0cbadad3ced2ba5c53bbb7e6ec3e779c1cd3966c'

  devel do
    url 'http://services.gradle.org/distributions-snapshots/gradle-1.9-20130911220033+0000-bin.zip'
    sha1 '39a3ec87bb304eaba9de5c736f0149343fe5d20a'
    version '1.9-20130911220033'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
