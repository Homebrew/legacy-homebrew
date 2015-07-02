class DependencyCheck < Formula
  desc "OWASP Dependency Check"
  homepage "https://www.owasp.org/index.php/OWASP_Dependency_Check"
  url "https://dl.bintray.com/jeremy-long/owasp/dependency-check-1.2.11-release.zip"
  version "1.2.11"
  sha256 "1a622a1c79a7bff88950fa42294d634a8155958960d656d9d796785f056d88b2"

  depends_on :java

  def install
    rm_f Dir["bin/*.bat"]

    chmod 0755, "bin/dependency-check.sh"

    prefix.install_metafiles
    libexec.install Dir["*"]

    File.rename "#{libexec}/bin/dependency-check.sh", "#{libexec}/bin/dependency-check"
    (HOMEBREW_PREFIX/"bin").install_symlink libexec/"bin/dependency-check"

    # Now, link var/dependencycheck to the default data directory
    (var/"dependencycheck").mkpath
    ln_s var/"dependencycheck", libexec/"data"

    # Extract the included properties to etc and link
    (etc/"dependencycheck").mkpath
    corejar = libexec/"repo/org/owasp/dependency-check-core/#{version}/dependency-check-core-#{version}.jar"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", etc/"dependencycheck"
    ln_s etc/"dependencycheck", libexec/"etc"
  end

  test do
    output = `#{libexec}/bin/dependency-check.sh --version`.strip
    assert_equal('Dependency-Check Core version 1.2.11', output)
  end
end
