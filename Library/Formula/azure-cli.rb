class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/Azure/azure-xplat-cli/archive/v0.9.18-hotfix.tar.gz"
  version "0.9.18"
  sha256 "b53b6df87373eaff2d773d9fbcb6ef4ad96455e0b402117c0ff0d44c3c1ff3e0"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "7036a5008cb398128a2afa401cec986dd7af47717a720410a48abb37cc173db7" => :el_capitan
    sha256 "4ed0a90c367fd8656f192d1264eb2707d7abf6341fa5b452a1e52c3bd5c3ed81" => :yosemite
    sha256 "c4933dd1de6082e854bb94dfa117b52eeafa45edae605fde1c1da976fda089cf" => :mavericks
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
