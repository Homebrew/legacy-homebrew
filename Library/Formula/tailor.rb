class Tailor < Formula
  desc "Static analyzer for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.3.0/tailor-0.3.0.tar"
  sha256 "ecb9aeb9f7f7a6fd602a836c7caab21b655391ec6115eda41b763c4dfff3936e"

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
