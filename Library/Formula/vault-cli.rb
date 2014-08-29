require "formula"

class VaultCli < Formula
  homepage "http://jackrabbit.apache.org/filevault/index.html"
  url "http://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.1.6/vault-cli-3.1.6-bin.tar.gz"
  sha1 "3dd2c596ce8936c983e95b6cc868885f51b02992"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system "#{bin}/vlt", '--version'
  end

end
