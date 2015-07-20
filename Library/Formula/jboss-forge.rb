class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.17.0.Final&e=zip&c=offline"
  version "2.17.0.Final"
  sha256 "c0d8cadb315b23d99fb582db670ef32beea51b9b06ea9313ec81daa3998bedd8"

  bottle do
    cellar :any
    sha256 "4accd77051ff6cd0e425bbb17e6557b8110999430d1ab504336325605b198efc" => :yosemite
    sha256 "aff4bb3754d83399de23494e3f223cd071678cd5f5a204b4883f0ecb784c4290" => :mavericks
    sha256 "d69a922b8ac9cf315f8e2af074c068e163b13aa551bfc7641c557f7bc137305e" => :mountain_lion
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin img lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
