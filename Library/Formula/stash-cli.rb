class StashCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-4.3.0-distribution.zip"
  version "4.3.0"
  sha256 "b0487ad7795d1970de09d21c17ebea9caf1d7f9c12449c5102a88b0521e2c363"

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
      assert shell_output(bin/"#{cmd} --help 2>&1 | head").include?("Usage:") unless cmd == "atlassian"
    end
  end
end
