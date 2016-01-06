class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-250.tar.gz"
  version "20150426-250"
  sha256 "8590731dcbfb900e46b7073ff5d99f7df542da488f97fbaa5c70999f45ca69b4"

  bottle do
    cellar :any
    sha256 "a8acc895c3c7d2b214c0fc3ba19191deb5b3293566377dc6a7d30ebbcd77c254" => :yosemite
    sha256 "707e8bdf07687133290f9cfc3d3ab4861ee23785c154ef825a134ab5dc6363de" => :mavericks
    sha256 "22ec2c5971a36b82121cdf25135613fc7bcbbe13a4f77c56141ff5dda01ad0d5" => :mountain_lion
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true"

    libexec.install Dir["*"]
    inreplace libexec/"jmxtrans.sh", '"jmxtrans-all.jar"',
                                     "\"#{libexec}/target/jmxtrans-249-all.jar\""

    (libexec/"jmxtrans.sh").chmod 0755
    bin.install_symlink libexec/"jmxtrans.sh" => "jmxtrans"
  end

  test do
    output = shell_output("#{bin}/jmxtrans status", 3).chomp
    assert_equal "jmxtrans is not running.", output
  end
end
