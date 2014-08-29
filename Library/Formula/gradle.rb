require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://downloads.gradle.org/distributions/gradle-2.0-bin.zip'
  sha1 '171d2290257c061a96410297f2596596862a847a'

  devel do
    url 'https://services.gradle.org/distributions/gradle-2.1-rc-2-bin.zip'
    sha1 '2bb328ff832ad205201190559a2fada3206f2492'
    version '2.1-rc-2'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
