class Bfg < Formula
  desc "Removes large files or passwords from Git history like git-filter-branch does, but faster."
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.5/bfg-1.12.5.jar"
  sha256 "fa797cc6e5878a3b7b61104f3a3ba3d43987e2a7a9c596cb9d137c7b95e6b082"

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.5.jar"
    bin.write_jar_script libexec/"bfg-1.12.5.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
