require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'https://services.gradle.org/distributions/gradle-1.12-bin.zip'
  sha1 '4fee5af4ce5c1214bdbd5e14ef6adda9929f589f'

  devel do
    url 'https://services.gradle.org/distributions/gradle-2.0-rc-1-bin.zip'
    sha1 '44be0a1f08b2424cc9a2482d463c06524db3abf3'
    version '2.0-rc-1'
  end

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
