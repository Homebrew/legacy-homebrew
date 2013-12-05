require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.9-bin.zip'
  sha1 'e35f498e7e52d2ee3a12d313eb4c3d7805e6a346'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.10-rc-1-bin.zip'
    sha1 '3f55ac6595e94675ff4d568108d643cf6348f747'
    version '1.10-rc-1'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
