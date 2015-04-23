class Mahout < Formula
  homepage "https://mahout.apache.org/"
  url "http://apache.fayea.com/mahout/0.10.0/mahout-distribution-0.10.0-src.tar.gz"
  sha256 "69e3793866695911a5109c8d38af2b3d68dd421687dc8f666306cb3221315103"

  head "https://github.com/apache/mahout.git"

  depends_on :java
  depends_on "maven" => :build
  depends_on "hadoop"

  def install
    system "mvn", "-DskipTests", "clean", "install"

    libexec.install "bin"

    libexec.install Dir["buildtools/target/*.jar"]
    libexec.install Dir["core/target/*.jar"]
    libexec.install Dir["examples/target/*.jar"]
    libexec.install Dir["math/target/*.jar"]

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Mahout requires JAVA_HOME to be set:
      export JAVA_HOME=$(/usr/libexec/java_home)
    EOS
  end
end
