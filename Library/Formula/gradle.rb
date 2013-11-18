require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.8-bin.zip'
  sha1 'f14299582a1ab6c1293a43697ecda4b2673e34b1'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.9-rc-4-bin.zip'
    sha1 '18967c087f0109a1d5971faf3c31e83cd8a5d938'
    version '1.9-rc4'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
