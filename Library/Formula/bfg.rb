class Bfg < Formula
  desc "Alternative to git-filter-branch, written in Scala"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.3/bfg-1.12.3.jar"
  sha1 "4eff57d0418958815681cbbec2f19ed7285252cb"

  def install
    libexec.install "bfg-1.12.3.jar"
    bin.write_jar_script libexec/"bfg-1.12.3.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
