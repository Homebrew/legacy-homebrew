class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.6.0/tailor-0.6.0.tar"
  sha256 "3082448cbce0d7cea9c3fa119e5f1bb5e7ff53801fd506c94a2bfe3bef4f3145"

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
