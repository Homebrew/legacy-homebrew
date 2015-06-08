require "formula"

class Crash < Formula
  desc "Kernel debugging shell for Java that allows gdb-like syntax"
  homepage "http://www.crashub.org/"
  url "http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.1/crash.distrib-1.3.1.tar.gz"
  sha1 "0f6c157dda63f9d828d558c8b329344a6d17c7e9"

  resource "docs" do
    url "http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.1/crash.distrib-1.3.1-docs.tar.gz"
    sha1 "56957cb06b5600ca739c87070477cf066757f3ec"
  end

  def install
    doc.install resource("docs")
    libexec.install Dir["crash/*"]
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
