class Legit < Formula
  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "http://www.git-legit.org/"
  url "https://github.com/kennethreitz/legit/archive/v0.2.0.tar.gz"
  sha256 "dce86a16d9c95e2a7d93be75f1fc17c67d3cd2a137819fa498e179bf21daf39e"

  def install
    bin.install "legit"
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "init"
    system "#{bin}/legit", "sprout", "test"
    assert_match(/test/, shell_output("#{bin}/legit branches"))
  end
end
