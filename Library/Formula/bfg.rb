class Bfg < Formula
  desc "Alternative to git-filter-branch, written in Scala"
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.12.3/bfg-1.12.3.jar"
  sha256 "2e237631235cfb8cc2d49dabb986389851dca8a28a07083345274b443dfa4911"

  def install
    libexec.install "bfg-1.12.3.jar"
    bin.write_jar_script libexec/"bfg-1.12.3.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
