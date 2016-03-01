class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "http://www.jython.org"

  stable do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar"
    sha256 "b44352ece72382268a60e2848741c96609a91d796bb9a9c6ebeff62f0c12c9cf"
  end
  bottle do
    sha256 "12a261c1f35421587b21cb1e9de24dbe109716746c5393d8d2046e15aab0b821" => :el_capitan
    sha256 "2cfee4b728f3eb12528b66f53efee4fd2963c8da4103a47a1789afe75f1d5192" => :yosemite
    sha256 "a20a699bcbec43953cec0f8de72dc98ceef2264fc62744cc62d0a96c5e2b175e" => :mavericks
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
