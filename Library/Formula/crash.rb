class Crash < Formula
  desc "Kernel debugging shell for Java that allows gdb-like syntax"
  homepage "http://www.crashub.org/"
  url "https://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.1/crash.distrib-1.3.1.tar.gz"
  sha256 "d79f1cda660c0086c353b7a11bccf98c4c6c4f2026d80916dd896fd914b177e4"

  bottle :unneeded

  resource "docs" do
    url "https://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.1/crash.distrib-1.3.1-docs.tar.gz"
    sha256 "c594c005452fa02a54c60b47c82883b7a12e2293c00d1da24a9203b8d5898413"
  end

  def install
    doc.install resource("docs")
    libexec.install Dir["crash/*"]
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
