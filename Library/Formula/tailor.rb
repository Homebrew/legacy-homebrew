class Tailor < Formula
  desc "Static analyzer for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.4.0/tailor-0.4.0.tar"
  sha256 "c85481043d58c5b17bf560bcccebf1bf2b3009d84c9df66819ca10da20c61255"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tailor"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/tailor", testpath/"Test.swift"
  end
end
