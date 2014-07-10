require "formula"

# maven must use java 7, there are edge cases where java 7 is installed and mvn is not using it.
class MvnMinJavaRequirement < Requirement
  fatal true

  satisfy :build_env => false do
    mvn = `mvn -v`
    mvn.empty?

    # pull java version out of mvn stdio
    java_v = mvn.split("Java version:")[1].split(",")[0].strip

    # java 1.0-1.6 is invalid
    invalid = java_v =~/1.[0-6].*./
    invalid.nil?
  end

  def message; <<-EOS.undent
    Maven is not using Java 7+, here is how to fix it:

      1. Set Java_HOME to Java 7, or read solutions: https://stackoverflow.com/questions/18813828/why-maven-use-jdk-1-6-but-my-java-version-is-1-7
      2. Re-run `brew install mesos`
    EOS
  end
end

class Mesos < Formula
  homepage "http://mesos.apache.org"
  version "0.19.0"
  url "http://mirror.cogentco.com/pub/apache/mesos/0.19.0/mesos-0.19.0.tar.gz"
  sha1 "68d898e089a6b806fc88e0b1840f2dc4068cb5fe"

  depends_on "maven" => :build
  depends_on MvnMinJavaRequirement

  def install
    system "./configure", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    require "timeout"

    master = fork do
      exec "#{sbin}/mesos-master", "--ip=127.0.0.1",
                                   "--registry=in_memory"
    end
    slave = fork do
      exec "#{sbin}/mesos-slave", "--master=127.0.0.1:5050",
                                  "--work_dir=#{testpath}"
    end
    Timeout::timeout(15) do
      system "#{bin}/mesos", "execute",
                             "--master=127.0.0.1:5050",
                             "--name=execute-touch",
                             "--command=touch\s#{testpath}/executed"
    end
    Process.kill("TERM", master)
    Process.kill("TERM", slave)
    system "[ -e #{testpath}/executed ]"
  end
end
