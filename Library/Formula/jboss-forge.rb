class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/2.20.1.Final/forge-distribution-2.20.1.Final-offline.zip"
  version "2.20.1.Final"
  sha256 "dbe51b8c9cd0cf1b0a9adadcd8161c442a4ab586ca63f3a3f6d3369a2831afae"

  bottle :unneeded

  devel do
    url "https://downloads.jboss.org/forge/releases/3.0.0.CR1/forge-distribution-3.0.0.CR1-offline.zip"
    version "3.0.0.CR1"
    sha256 "2297478830ea01e69eb07122065d5760c7fd27b27668b1aa7e01e0d9e4e07458"
  end

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
