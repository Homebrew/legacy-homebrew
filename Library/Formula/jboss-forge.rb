class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/2.20.0.Final/forge-distribution-2.20.0.Final-offline.zip"
  version "2.20.0.Final"
  sha256 "ee4f9b2fff8ac72714cfd0c852735fcdd04e1b4462de8a6ba0807cbe3df4503f"

  bottle do
    cellar :any_skip_relocation
    sha256 "700167db26aa4ee2b502807ff444879662fb645e3e126b9cff0929c9fbcc6c4b" => :el_capitan
    sha256 "709aa0df9229e169fe1005763d51fe33be652348f6c45662955e41392ef8e9ab" => :yosemite
    sha256 "e100821705db0ec9db49eb0f1ae05746b2f2bbfcbf74f1df6fa14bf86ad85a42" => :mavericks
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
