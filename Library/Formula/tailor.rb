class Tailor < Formula
  desc "Static analyzer for Swift"
  homepage "http://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.2.1/tailor.tar"
  version "0.2.1"
  sha256 "9b6cb6f88aafcf5f6b4dfbc88c51f6af73d07c070eafe2d05409db84918cf17b"

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
