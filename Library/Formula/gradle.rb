require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.8-bin.zip'
  sha1 'f14299582a1ab6c1293a43697ecda4b2673e34b1'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.9-rc-3-bin.zip'
    sha1 '9c4dc0aaddd20f2a5a9ba6dd7367033ec975ab2c'
    version '1.9-rc3'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
