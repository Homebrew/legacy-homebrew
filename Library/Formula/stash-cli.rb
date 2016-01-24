class StashCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-4.5.0-distribution.zip"
  version "4.5.0"
  sha256 "79fc81d3b383348702cb6d24983fe002aefe4a9b859380bcdd1f19e78ac6f046"

  bottle do
    cellar :any_skip_relocation
    sha256 "3038b2e790d2bcdcc13fffa7009dc9597e02c0acd4299de38cb86829db66eb3f" => :el_capitan
    sha256 "9408dc3d097f408438541e4cfe1b78a338a63a9c001d4ae470092ae66736a14c" => :yosemite
    sha256 "8c792a3010db1e0a5432699da4ee2e7a24fdb921e930db713ac48876d2eafb02" => :mavericks
  end

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
      assert_match "Usage:", shell_output(bin/"#{cmd} --help 2>&1 | head") unless cmd == "atlassian"
    end
  end
end
