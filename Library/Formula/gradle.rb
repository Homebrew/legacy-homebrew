class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.2-bin.zip"
  sha256 "8d7437082356c9fd6309a4479c8db307673965546daea445c6c72759cd6b1ed6"

  bottle :unneeded

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end

  test do
    ENV.java_cache
    output = shell_output("#{bin}/gradle --version")
    assert_match /Gradle #{version}/, output
  end
end
