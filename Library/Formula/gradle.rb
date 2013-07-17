require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.6-bin.zip'
  sha1 '631650e2b0aa8dea45f94a999ecab850d0f07370'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.7-rc-1-bin.zip'
    sha1 '13750fd7274fac0ec5f54719e0a5bba7eba0ba46'
    version '1.7-rc1'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
