require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.1-bin.zip'
  sha1 '938b2a4e40fd2fd701c5138edbcbab54b9b7f85e'

  devel do
    url 'http://services.gradle.org/distributions/gradle-1.2-rc-1-bin.zip'
    sha1 '3e64ca9c8cbf1f03da4d5c20a42cb46464d0a820'
    version '1.2-rc1'
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/gradle'
  end
end
