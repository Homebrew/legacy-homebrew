class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.0.0.Beta1/forge-distribution-3.0.0.Beta1-offline.zip"
  version "3.0.0.Beta1"
  sha256 "d1e4e57ff234c5fe4dee376688e4f0a7ff1a995189c12315afa21b4a619cbf50"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    ENV["FORGE_OPTS"] = "-Duser.home=#{testpath}"
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
