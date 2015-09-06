class AmdatuBootstrap < Formula
  desc "Bootstrapping OSGi development"
  homepage "http://amdatu.org/bootstrap/intro.html"
  url "https://bitbucket.org/amdatu/amdatu-bootstrap/downloads/bootstrap-r8-bin-brew.zip"
  sha256 "f2f66af5a6b9725e260509c0a0e9996c1e3b7f696a96309b0a2a399975a9a732"

  def install
    libexec.install %w[amdatu-bootstrap bootstrap.jar conf]
    bin.install_symlink "#{libexec}/amdatu-bootstrap" => "amdatu-bootstrap"
  end
end
