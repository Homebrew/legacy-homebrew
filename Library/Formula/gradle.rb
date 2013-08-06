require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.7-bin.zip'
  sha1 '0cbadad3ced2ba5c53bbb7e6ec3e779c1cd3966c'

  devel do
    #1.7 is currently the most recent rc
    #url 'http://services.gradle.org/distributions/gradle-1.7-rc-2-bin.zip'
    #sha1 'c2117683acbfaaa5eb7a1a93220f6290f8835f2f'
    #version '1.7-rc2'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
