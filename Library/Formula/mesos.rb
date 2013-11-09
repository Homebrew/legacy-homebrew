require 'formula'

class Mesos < Formula
  homepage 'http://mesos.apache.org'
  version '0.14.1'
  url 'http://www.webhostingjams.com/mirror/apache/mesos/0.14.1/mesos-0.14.1.tar.gz'
  sha1 '0b8e7ebd9c8a28f073b955f7229c5a28ee2d7120'

  fails_with :clang do
    cause 'struct/class definition mismatches'
  end

  fails_with :gcc do
    cause 'multiple configure and compile errors'
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

  def install
    java_home = `/usr/libexec/java_home -v '1.7'`.chomp
    unless $?.success?
      puts <<-MSG

Couldn't locate JDK7, here is how to fix it:

  1. Download and install JDK7 from http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
  2. Verify that it has been installed by running /usr/libexec/java_home -v '1.7'
  3. Re-run brew install mesos

      MSG
    end

    system "./configure", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"

    system "make"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "test", "-x", "#{bin}/mesos-local"
  end
end
