class Flyway < Formula
  homepage "http://flywaydb.org/"
  url "https://bintray.com/artifact/download/business/maven/flyway-commandline-3.2.1-macosx-x64.tar.gz"
  sha256 "f65a3a7c16fb29839fb68abaead5cdc08d8d6e77ae0d9ae741a820841c78fa41"
  version "3.2.1"

  def install
    rm Dir["*.cmd"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/flyway"]
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
