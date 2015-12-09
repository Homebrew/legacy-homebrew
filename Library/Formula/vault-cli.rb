class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/3.1.6/vault-cli-3.1.6-bin.tar.gz"
  sha256 "639ccdc5c70eb75c2423b6ae62e0560a2056d2cea34cc82ed99504a097bfce88"

  bottle :unneeded

  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system "#{bin}/vlt", "--version"
  end
end
