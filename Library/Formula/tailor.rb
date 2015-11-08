class Tailor < Formula
  desc "Static analyzer for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.2.2/tailor.tar"
  version "0.2.2"
  sha256 "84d12cddd06ed1592933e52991c1e5d4a9b529e31fc41ea4e03f11fd25a2af77"

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
