class StashCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://marketplace.atlassian.com/download/plugins/org.swift.atlassian.cli/version/450"
  version "4.5.0"
  sha256 "79fc81d3b383348702cb6d24983fe002aefe4a9b859380bcdd1f19e78ac6f046"

  depends_on :java => "1.7+"

  def install
    Dir.glob("*.sh") do |f|
      cmd = File.basename(f, ".sh")
      inreplace cmd + ".sh", "`dirname $0`", share
      bin.install cmd + ".sh" => cmd
    end
    share.install "lib", "license"
  end

  test do
    Dir.glob(bin/"*") do |f|
      cmd = File.basename(f, ".sh")
      assert_match "Usage:", shell_output(bin/"#{cmd} --help 2>&1") unless cmd == "atlassian"
    end
  end
end
