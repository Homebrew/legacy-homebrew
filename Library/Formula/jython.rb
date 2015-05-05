class Jython < Formula
  homepage "http://www.jython.org"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar"
  sha1 "b08d73b5df7d95e35e7b8dcaf1558025cf24f0f1"

  devel do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7-rc3/jython-installer-2.7-rc3.jar"
    sha256 "882b0139b302a2bfd1158e3b6640530dc224be7ce10d850df0b6d28e63f869f1"
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    inreplace libexec/"bin/jython", "PRG=$0", "PRG=#{libexec}/bin/jython" if build.stable?
    bin.install_symlink libexec/"bin/jython"
  end
end
