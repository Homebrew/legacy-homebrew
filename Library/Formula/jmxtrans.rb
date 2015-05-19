class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-249.tar.gz"
  version "20150330-249"
  sha256 "770699c04d3cbc36f877551821e15b6daa6dd9decf76b971f70534533854f7f2"

  bottle do
    cellar :any
    sha256 "a8acc895c3c7d2b214c0fc3ba19191deb5b3293566377dc6a7d30ebbcd77c254" => :yosemite
    sha256 "707e8bdf07687133290f9cfc3d3ab4861ee23785c154ef825a134ab5dc6363de" => :mavericks
    sha256 "22ec2c5971a36b82121cdf25135613fc7bcbbe13a4f77c56141ff5dda01ad0d5" => :mountain_lion
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
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
    assert_equal "jmxtrans is not running.",
                 shell_output("#{bin}/jmxtrans status", 3).chomp
  end
end
