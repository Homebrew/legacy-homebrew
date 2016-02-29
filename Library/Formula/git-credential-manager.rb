class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://java.visualstudio.com/Docs/tools/gitcredentialmanager"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-1.4.0/git-credential-manager-1.4.0.jar"
  sha256 "9a2c405b1876753734774fc63dc01ce8751d4af1a892bea59f823d996624efec"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "git-credential-manager-#{version}.jar"
    bin.write_jar_script libexec/"git-credential-manager-#{version}.jar", "git-credential-manager"
  end

  test do
    system "#{bin}/git-credential-manager", "version"
  end
end
