class PaxConstruct < Formula
  desc "Tools to setup and develop OSGi projects quickly"
  homepage "https://ops4j1.jira.com/wiki/display/paxconstruct/Pax+Construct"
  url "https://repo1.maven.org/maven2/org/ops4j/pax/construct/scripts/1.5/scripts-1.5.zip"
  sha256 "d0325bbe571783097d4be782576569ea0a61529695c14e33a86bbebfe44859d1"

  bottle :unneeded

  # Needed at runtime! pax-clone: line 47: exec: mvn: not found
  depends_on "maven"

  def install
    rm_rf Dir["bin/*.bat"]
    prefix.install_metafiles "bin" # Don't put these in bin!
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
  end

  test do
    ENV.java_cache

    system bin/"pax-create-project", "-g", "Homebrew", "-a", "testing",
               "-v", "alpha-1"
    assert File.exist?("testing/pom.xml")
  end
end
