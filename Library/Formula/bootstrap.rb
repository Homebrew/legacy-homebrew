class Bootstrap < Formula
  desc "Bootstrapping OSGi development"
  homepage "http://amdatu.org/bootstrap/intro.html"
  url "https://bitbucket.org/amdatu/amdatu-bootstrap/downloads/bootstrap-r8-bin-brew.zip"
  version "r8"
  sha256 "386c9f69a8bc1e12908d0a9b41c40c126c0f95627bc81d3d15bd868649798f91"

   def install
    libexec.install %w[bootstrap bootstrap.jar conf]
    bin.install_symlink "#{libexec}/bootstrap" => "bootstrap"
  end
end
