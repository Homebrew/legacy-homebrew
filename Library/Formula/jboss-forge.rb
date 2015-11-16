class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/2.20.1.Final/forge-distribution-2.20.1.Final-offline.zip"
  version "2.20.1.Final"
  sha256 "dbe51b8c9cd0cf1b0a9adadcd8161c442a4ab586ca63f3a3f6d3369a2831afae"

  bottle :unneeded

  devel do
    url "https://downloads.jboss.org/forge/releases/3.0.0.Alpha1/forge-distribution-3.0.0.Alpha1-offline.zip"
    version "3.0.0.Alpha1"
    sha256 "81d4ecafd3f555b81c139ab9c56ed79104714678bc47c5703ddb2875628afb1e"
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
