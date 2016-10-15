class StashCli < Formula
  homepage "https://bobswift.atlassian.net/wiki/display/SCLI/Stash+Command+Line+Interface"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/stash-cli-3.9.0-distribution.zip?api=v2"
  version "3.9.0"
  sha1 "f615519894b194959754b9a7b5fb9bc03855dbcd"

  def install
    inreplace "stash.sh", "`dirname $0`", share
    share.install "lib", "license"
    bin.install "stash.sh" => "stash"
  end

  test do
    assert shell_output(bin/"stash --help 2>&1 | head").include?("Usage:")
  end
end
