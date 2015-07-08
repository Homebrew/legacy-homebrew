class Legit < Formula
  desc "Command-line interface for Git, optimized for workflow simplicity"
  homepage "http://www.git-legit.org/"
  url "https://github.com/downloads/kennethreitz/legit/legit-v0.1.0-darwin-x86.tar.bz2"
  version "0.1.0"
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
