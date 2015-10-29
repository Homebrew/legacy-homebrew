class PaxConstruct < Formula
  desc "Tools to setup and develop OSGi projects quickly"
  homepage "http://wiki.ops4j.org/display/paxconstruct/Pax+Construct"
  url "https://repo1.maven.org/maven2/org/ops4j/pax/construct/scripts/1.5/scripts-1.5.zip"
  sha256 "d0325bbe571783097d4be782576569ea0a61529695c14e33a86bbebfe44859d1"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    prefix.install_metafiles "bin" # Don't put these in bin!
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
