class Nimble < Formula
  desc "Beta-grade package manage for Nim"
  homepage "https://github.com/nim-lang/nimble"
  url "https://github.com/nim-lang/nimble/archive/v0.6.2.tar.gz"
  sha256 "b5862cd2363360b16dbe629a09466f534b3c225890b95cd86f42bda675a774fb"

  depends_on "nimrod"

  def install
    system "nim", "c", "-r", "src/nimble", "install"
    bin.install "nimble"
  end

  test do
    assert_match /^nimble/, shell_output("#{bin}/nimble --version")
    assert_match /Please specify a search string/, shell_output("#{bin}/nimble search", 1)
  end
end
