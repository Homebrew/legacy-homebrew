class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://java.visualstudio.com/Docs/tools/gitcredentialmanager"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-1.6.0/git-credential-manager-1.6.0.jar"
  sha256 "ff86d25c4d1760bdb14f69d17a7c290b34a82292aa9ea9bdf00e7c57f5ed53a1"

  bottle :unneeded

  if MacOS.version >= :el_capitan
    depends_on :java => "1.8+"
  else
    depends_on :java => "1.7+"
  end

  def install
    libexec.install "git-credential-manager-#{version}.jar"
    bin.write_jar_script libexec/"git-credential-manager-#{version}.jar", "git-credential-manager"
  end

  test do
    system "#{bin}/git-credential-manager", "version"
  end
end
