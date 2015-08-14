class Legit < Formula
  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "http://www.git-legit.org/"
  url "https://github.com/kennethreitz/legit/archive/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "9b25a4c8e12d6703627ba24f4547a7d4350ca1ef9fa44415512b1bcc57b06506"

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
