class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.5-bin.zip"
  sha256 "3f953e0cb14bb3f9ebbe11946e84071547bf5dfd575d90cfe9cc4e788da38555"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end
end
