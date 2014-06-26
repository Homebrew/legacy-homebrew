require "formula"
require "timeout"

class Java7Requirement < Requirement
  fatal true

  satisfy :build_env => false do
    system "/usr/libexec/java_home", "-v", "1.7"
  end

  def message; <<-EOS.undent
    Couldn't locate JDK7, here is how to fix it:

      1. Download and install JDK7 from http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
      2. Verify that it has been installed by running `/usr/libexec/java_home -v 1.7`
      3. Re-run `brew install mesos`
    EOS
  end
end

class Mesos < Formula
  homepage "http://mesos.apache.org"
  version "0.19.0"
  url "http://mirror.cogentco.com/pub/apache/mesos/0.19.0/mesos-0.19.0.tar.gz"
  sha1 "68d898e089a6b806fc88e0b1840f2dc4068cb5fe"

  depends_on Java7Requirement
  depends_on "maven" => :build

  def install
    system "./configure", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
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
