class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.9-bin.zip"
  sha256 "c9159ec4362284c0a38d73237e224deae6139cbde0db4f0f44e1c7691dd3de2f"

  bottle :unneeded

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end

  test do
    output = shell_output("#{bin}/gradle --version")
    assert_match /Gradle #{version}/, output
  end
end
