class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "http://www.jython.org"

  stable do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar"
    sha256 "b44352ece72382268a60e2848741c96609a91d796bb9a9c6ebeff62f0c12c9cf"
  end

  devel do
    url "http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.1b3/jython-installer-2.7.1b3.jar"
    sha256 "5c6c7dc372a131dbc2b29b95407c69a4ebab22c1823d9098b7f993444f3090c5"
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    bin.install_symlink libexec/"bin/jython"
  end
end
