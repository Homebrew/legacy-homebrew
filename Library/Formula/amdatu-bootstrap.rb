class AmdatuBootstrap < Formula
  desc "Bootstrapping OSGi development"
  homepage "http://amdatu.org/bootstrap/intro.html"
  url "https://bitbucket.org/amdatu/amdatu-bootstrap/downloads/bootstrap-bin-r9.zip"
  sha256 "937ef932a740665439ea0118ed417ff7bdc9680b816b8b3c81ecfd6d0fc4773b"

  bottle :unneeded

  def install
    libexec.install %w[amdatu-bootstrap bootstrap.jar conf]
    bin.install_symlink "#{libexec}/amdatu-bootstrap" => "amdatu-bootstrap"
  end

  test do
    assert_match "Amdatu Bootstrap R9", shell_output("#{bin}/amdatu-bootstrap --info")
  end
end
