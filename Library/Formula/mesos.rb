require "formula"

class Java7Requirement < Requirement
  fatal true

  def java_home_cmd
    "/usr/libexec/java_home -v '1.7'"
  end

  satisfy :build_env => false do
    system *java_home_cmd.split(" ")
    $?.success?
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
    system "#{sbin}/mesos-master", "--version"
  end
end
