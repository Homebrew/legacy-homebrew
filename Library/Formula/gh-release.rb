class GhRelease < Formula
  desc "Utility for automating GitHub releases with file uploads"
  homepage "https://github.com/progrium/gh-release"
  url "https://github.com/progrium/gh-release/releases/download/v2.2.0/gh-release_2.2.0_darwin_x86_64.tgz"
  version "2.2.0"
  sha256 "b272576d9fd6449caa30e64e82f683a0bbc240eadf3be42fad4d8d2c7bd86eef"

  def install
    bin.install "gh-release"
  end

  test do
    system "#{bin}/gh-release", "--help"
  end
end
