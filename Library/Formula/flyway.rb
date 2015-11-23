class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "http://flywaydb.org/"
  url "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/3.2.1/flyway-commandline-3.2.1.tar.gz"
  sha256 "da942c3b96d89ca221617a720c1945d16dadf142313380a71a825e62821d0a2b"

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
