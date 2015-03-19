class Gradle < Formula
  homepage "http://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.3-bin.zip"
  sha256 "010dd9f31849abc3d5644e282943b1c1c355f8e2635c5789833979ce590a3774"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end
end
