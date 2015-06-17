class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "http://devel.ringlet.net/sysutils/timelimit/"
  url "http://devel.ringlet.net/sysutils/timelimit/timelimit-1.8.tar.gz"
  sha256 "026e72b345f8407ebaa002036fd785b2136b2dfc4f8854f14536196ee3079996"

  def install
    # don't install for a specific user
    inreplace "Makefile", "-o ${BINOWN} -g ${BINGRP}", ""
    inreplace "Makefile", "-o ${MANOWN} -g ${MANGRP}", ""

    args = %W[LOCALBASE=#{prefix} MANDIR=#{man}/man]

    check_args = args + ["check"]
    install_args = args + ["install"]

    system "make", *check_args
    system "make", *install_args
  end

  test do
    assert_equal "timelimit: sending warning signal 15",
      shell_output("#{bin}/timelimit -p -t 1 sleep 5 2>&1", 143).chomp
  end
end
