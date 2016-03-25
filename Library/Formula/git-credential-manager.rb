class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://java.visualstudio.com/Docs/tools/gitcredentialmanager"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-1.5.0/git-credential-manager-1.5.0.jar"
  sha256 "e5e685c6938e0955dabe91829d3bb4aaea9bce2bb1c6ecc6f405b74b4ce2b346"

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
