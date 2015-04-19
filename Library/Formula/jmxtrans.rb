class Jmxtrans < Formula
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-249.tar.gz"
  version "20150330-249"
  sha256 "770699c04d3cbc36f877551821e15b6daa6dd9decf76b971f70534533854f7f2"

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
