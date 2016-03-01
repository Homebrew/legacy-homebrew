class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "http://flywaydb.org/"
  url "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.0/flyway-commandline-4.0.tar.gz"
  sha256 "218a7f6b3ac629f084e417bbaecd06ad9723704832aa72a81c6e096ac55aacd4"

  bottle :unneeded

  depends_on :java

  def install
    rm Dir["*.cmd"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/flyway"]
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
