class Storm < Formula
  homepage "http://storm.apache.org"
  url "http://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-0.9.3/apache-storm-0.9.3.tar.gz"
  sha1 "33545afc72281d6e8b497fcbdf2b9944eebb83aa"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/storm"
  end
end
