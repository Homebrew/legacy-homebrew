class Bfg < Formula
  desc "Remove large files or passwords from Git history like git-filter-branch"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.8/bfg-1.12.8.jar"
  sha256 "107efdf53cd5a864275128aacc1e7c2986ac6b162941b309938f94975fcfd3e8"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bfg-1.12.8.jar"
    bin.write_jar_script libexec/"bfg-1.12.8.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
