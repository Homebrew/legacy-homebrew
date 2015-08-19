class Bfg < Formula
  desc "Removes large files or passwords from Git history like git-filter-branch does, but faster."
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.4/bfg-1.12.4.jar"
  sha256 "41e01861a7021a73db28860575fdeacab48dbcdcd48e658cf93df5ca06484b21"

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.4.jar"
    bin.write_jar_script libexec/"bfg-1.12.4.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
