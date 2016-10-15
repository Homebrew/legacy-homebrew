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

    File.rename "#{libexec}/bin/dependency-check.sh", \
      "#{libexec}/bin/dependency-check"
    bin.install_symlink libexec/"bin/dependency-check"

    (var/"dependencycheck").mkpath
    libexec.install_symlink var/"dependencycheck" => "data"

    (etc/"dependencycheck").mkpath
    corejar = libexec/"repo/org/owasp/dependency-check-core/#{version}/"\
      "dependency-check-core-#{version}.jar"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", \
      etc/"dependencycheck"
    libexec.install_symlink etc/"dependencycheck" => "etc"
  end

  test do
    output = `#{libexec}/bin/dependency-check --version`.strip
    assert_equal("Dependency-Check Core version 1.2.11", output)

    props = File.open("temp-props.properties", "w")
    props.puts "cve.startyear=2015"
    props.close

    system "#{bin}/dependency-check", "-P", "temp-props.properties", \
      "-f", "XML", "-a", "dc", "-s", libexec, "-d", testpath, "-o", testpath
    assert(File.exist?(testpath/"dependency-check-report.xml"))
  end
end
