class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/releases/download/v0.9.15-February2016/azure-cli.0.9.15.tar.gz"
  sha256 "250edeed008fccce9f802686e1615ad5609be892910d5d0809edb864b68c77e0"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "ece78be41a76a480c8578098fe3a10e1db32259ad6b2007e2bf21db0cffd4ddc" => :el_capitan
    sha256 "f72ee827bd18549ae59a7173d1c20ac8f21c2b42fd842fbeb7ae4ba1f587e6a3" => :yosemite
    sha256 "17b053270b261c16eadbb1a1103a301237b44577d4e062ac81623a8785ef9c21" => :mavericks
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
