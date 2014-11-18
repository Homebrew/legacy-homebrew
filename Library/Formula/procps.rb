require "formula"

class Procps < Formula
  homepage "http://procps.sourceforge.net/"
  url "http://procps.sourceforge.net/procps-3.2.8.tar.gz"
  sha1 "a0c86790569dec26b5d9037e8868ca907acc9829"

  def install
    # This first invocation of make fails.
    # The subsequent invocation of make succeeds.
    # ps/sortformat.o: In function `do_one_spec':
    # sortformat.c: undefined reference to `get_pid_digits'
    # collect2: error: ld returned 1 exit status
    # ps/module.mk:23: recipe for target 'ps/ps' failed
    system "make || true"
    system "make"

    # kill and uptime are also provided by coreutils
    system "make", "install",
      "SKIP=$(bin)kill $(man1)kill.1 $(bin)uptime $(man1)uptime.1",
      "install=install -D",
      "usr/bin=#{bin}/",
      "bin=#{bin}/",
      "sbin=#{sbin}/",
      "usr/proc/bin=#{bin}/",
      "man1=#{man1}/",
      "man5=#{man5}/",
      "man8=#{man8}/",
      "lib=#{lib}/",
      "usr/lib=#{lib}/",
      "usr/include=#{include}/"
  end

  test do
    system "#{bin}/ps --version"
    system "#{bin}/ps"
  end
end
