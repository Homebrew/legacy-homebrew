class GitCredentialManager < Formula
  desc "Stores credentials for Git on Visual Studio Online (VSO)"
  homepage "https://java.visualstudio.com/Docs/tools/intro"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-1.2.0/git-credential-manager-1.2.0.jar"
  sha256 "537c066469f3a232818cd876c9787ecf323e8e7b0cfb1bff4028fbb2315e07fc"

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
