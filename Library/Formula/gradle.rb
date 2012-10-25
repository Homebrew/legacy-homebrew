require 'formula'

class Gradle < Formula
  homepage 'http://www.gradle.org/'
  url 'http://services.gradle.org/distributions/gradle-1.2-bin.zip'
  sha1 'eeb372596534a813dd9ae7ff2f619567030946da'

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
