require 'formula'

class Java7Requirement < Requirement
  fatal true

  def java_home_cmd
    "/usr/libexec/java_home -v 1.7"
  end

  satisfy :build_env => false do
    system *java_home_cmd.split(" ")
  end

  def message; <<-EOS.undent
    Couldn't locate JDK7, here is how to fix it:

      1. Download and install JDK7 from http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
      2. Verify that it has been installed by running #{java_home_cmd}
      3. Re-run brew install mesos
    EOS
  end
end

class Mesos < Formula
  homepage 'http://mesos.apache.org'
  url 'http://www.webhostingjams.com/mirror/apache/mesos/0.14.1/mesos-0.14.1.tar.gz'
  sha1 '0b8e7ebd9c8a28f073b955f7229c5a28ee2d7120'

  fails_with :clang do
    cause 'struct/class definition mismatches'
  end

  fails_with :gcc do
    cause 'multiple configure and compile errors'
  end

  depends_on Java7Requirement

  def install
    system "./configure", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      Mesos doesn't install on clang or apple-gcc-4.2.
      The only compiler I had luck with was gcc-4.6.

      Make sure to do the following:
        1. brew install gcc46
        2. brew install mesos --cc=gcc-4.6
    EOS
  end
end
