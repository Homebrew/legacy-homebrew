require "formula"

class Crash < Formula
  homepage "http://www.crashub.org/"
  url "http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0/crash.distrib-1.3.0.tar.gz"
  sha1 "77ffc46cfead3ac6bb757830661e500f0c1b7a2a"

  resource "docs" do
    url "http://search.maven.org/remotecontent?filepath=org/crashub/crash.distrib/1.3.0/crash.distrib-1.3.0-docs.tar.gz"
    sha1 "6386cf9d54c7463dcbad61d27fea6ce46ba409b5"
  end

  def install
    doc.install resource("docs")
    libexec.install Dir["crash/*"]
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
