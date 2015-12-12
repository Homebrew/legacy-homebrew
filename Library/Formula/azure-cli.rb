class AzureCli < Formula
  desc "Official Azure CLI"
  homepage "https://github.com/azure/azure-xplat-cli"
  url "https://github.com/azure/azure-xplat-cli/releases/download/v0.9.13-December2015/azure-cli.0.9.13.tar.gz"
  sha256 "f91e341c499624d6ba007ef3ad79d932c5b94a1f35acc49e3fbffd76c2317317"

  head "https://github.com/azure/azure-xplat-cli.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "faf354f229e336c131c7eeaa50257e3fd5a03e3cd4afc731982c1b4615832956" => :el_capitan
    sha256 "74f743ffad23cca801642faa1e967b0ad3c52a700887aa8a89a3db4304091f82" => :yosemite
    sha256 "8c4a14e8ce79f7010e0834d02199a928eed799bd3b1e5f910cc239aec450f462" => :mavericks
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
    (bash_completion/"azure").write system("#{bin}/azure", "--completion")
  end

  test do
    json_text = shell_output("#{bin}/azure account env show AzureCloud --json")
    azure_cloud = Utils::JSON.load(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["managementEndpointUrl"], "https://management.core.windows.net"
    assert_equal azure_cloud["resourceManagerEndpointUrl"], "https://management.azure.com/"
  end
end
