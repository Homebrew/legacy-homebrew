class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/2.19.0.Final/forge-distribution-2.19.0.Final-offline.zip"
  version "2.19.0.Final"
  sha256 "235ebe00b2e5c5f1ba80ea599592a976a9547f121345269fd2e61f873bb19fef"

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
