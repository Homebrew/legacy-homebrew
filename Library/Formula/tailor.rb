class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.5.1/tailor-0.5.1.tar"
  sha256 "649056946d39a6b12ba6ad1d86b0f184ed8dc76e77dfeb5e13d0802c9073a6ca"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tailor"
    man1.install libexec/"tailor.1"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/tailor", testpath/"Test.swift"
  end
end
