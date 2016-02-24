class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/releases/download/v0.9.15-February2016/azure-cli.0.9.15.tar.gz"
  sha256 "250edeed008fccce9f802686e1615ad5609be892910d5d0809edb864b68c77e0"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "725bfc90fc683857f1a0fb68a4f28c57f74149bdfb7de7145df1b61b97ab1a31" => :el_capitan
    sha256 "547f355dacad91cfccf14256e2876338c7e8bcbbb63ec2271fcd36693dfd42f2" => :yosemite
    sha256 "729adeb47184d8dbf28a6d9ad8acf0f3e30ee818c3f1593d5d6c4e926c9e770f" => :mavericks
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
