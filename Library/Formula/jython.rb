class Jython < Formula
  homepage "http://www.jython.org"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar"
  sha256 "b44352ece72382268a60e2848741c96609a91d796bb9a9c6ebeff62f0c12c9cf"

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    inreplace libexec/"bin/jython", "PRG=$0", "PRG=#{libexec}/bin/jython" if build.stable?
    bin.install_symlink libexec/"bin/jython"
  end
end
