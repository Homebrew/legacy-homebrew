class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.6-bin.zip"
  sha256 "18a98c560af231dfa0d3f8e0802c20103ae986f12428bb0a6f5396e8f14e9c83"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end
end
