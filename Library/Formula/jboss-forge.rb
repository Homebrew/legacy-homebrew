class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.18.0.Final&e=zip&c=offline"
  version "2.18.0.Final"
  sha256 "c191d741ed29eee5bbc2a31ba2fd83ad81b6672b79b47acdc4abe520fe057cee"

  bottle do
    cellar :any
    sha256 "da78b619648205a7ba737479f0aaf3295ed1a999a407b89f301882c569b7fc79" => :yosemite
    sha256 "b44f27108a15632dde330d380622079459812a2cf6787f3f8dc45ecb5b0c75c9" => :mavericks
    sha256 "a9c88bab36a57b0f0a69d323c27d1577beaed60bdf32f5ee00d487eae4a1bc65" => :mountain_lion
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin img lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    ENV["FORGE_OPTS"] = "-Duser.home=#{testpath}"
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
