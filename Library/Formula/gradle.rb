require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.6-bin.zip'
  sha1 '631650e2b0aa8dea45f94a999ecab850d0f07370'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.7-rc-2-bin.zip'
    sha1 'c2117683acbfaaa5eb7a1a93220f6290f8835f2f'
    version '1.7-rc2'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
