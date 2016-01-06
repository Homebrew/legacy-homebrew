class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-250.tar.gz"
  version "20150426-250"
  sha256 "8590731dcbfb900e46b7073ff5d99f7df542da488f97fbaa5c70999f45ca69b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d1adc9a2dc7f73c99d5bee85c78bf129afef269fe83cf4da1ac8c889cedfc9" => :el_capitan
    sha256 "a7e7e933f1da5c5ca88b0b399c9606d8805f7756dba8cf1ef7df0595e23f707c" => :yosemite
    sha256 "64337db305c727c34f20f619c647fc11f07b2ae9f1716e048ca954b13da179aa" => :mavericks
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
