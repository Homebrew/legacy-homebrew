class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.9.19-March2016.tar.gz"
  version "0.9.19"
  sha256 "8f0e4093a2a91097a2621f01cad435cc5856dadbe3e343c3538409e2c9386b11"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5c5ab9d2b9e451af0448a48200aa4f9bd8d0a1416bf975ba78743f68ae778f" => :el_capitan
    sha256 "656260824be014aefff7f0c5c9a0783993c2ded0b467a900d61a181ad8497106" => :yosemite
    sha256 "3c5be8a2921f122790e11722a54ef3a75c35144f523d0e1bf312f1c1250f14c5" => :mavericks
  end

  depends_on "node"

  def install
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
    # install node dependencies
    system "npm", "install"
    # remove windows stuff
    rm_rf "bin/windows"
    (prefix/"src").install Dir["lib", "node_modules", "package.json", "bin"]
    bin.install_symlink (prefix/"src/bin/azure")
    (bash_completion/"azure").write `#{bin}/azure --completion`
  end

  test do
    json_text = shell_output("#{bin}/azure account env show AzureCloud --json")
    azure_cloud = Utils::JSON.load(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["managementEndpointUrl"], "https://management.core.windows.net"
    assert_equal azure_cloud["resourceManagerEndpointUrl"], "https://management.azure.com/"
  end
end
