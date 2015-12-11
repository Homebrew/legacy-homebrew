class AmdatuBootstrap < Formula
  desc "Bootstrapping OSGi development"
  homepage "http://amdatu.org/bootstrap/intro.html"
  # The next release should not use a zip with "brew" in the name.
  url "https://bitbucket.org/amdatu/amdatu-bootstrap/downloads/bootstrap-r8-bin-brew.zip"
  sha256 "5c89667e10b57060c67fc54188ded3b0b281f88fab062bfb4290994e8df2295a"

  bottle :unneeded

  def install
    libexec.install %w[amdatu-bootstrap bootstrap.jar conf]
    bin.install_symlink "#{libexec}/amdatu-bootstrap" => "amdatu-bootstrap"
  end

  test do
    assert_match "Amdatu Bootstrap R8", shell_output("#{bin}/amdatu-bootstrap --info")
  end
end
