require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.8-bin.zip'
  sha1 'f14299582a1ab6c1293a43697ecda4b2673e34b1'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.9-rc-1-bin.zip'
    sha1 '9867a3ab08e40dcf5997319c2d262d7a4dc1bc0a'
    version '1.9-rc1'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
