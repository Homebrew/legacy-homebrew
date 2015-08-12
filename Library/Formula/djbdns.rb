class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  bottle do
    revision 1
    sha256 "5b35c66da0a07837375fe7c580674f842aad4ef91a4a0cc43bf10abca58a7ea4" => :el_capitan
    sha256 "6a1fda941f1a1bc403157b9e9a0610bcc1a8b3b73b5ef92c1d4bab39cc11619d" => :yosemite
    sha256 "5d42a7eb3f0e33ba6de7022957b3fcbe23d8e81dc623dfd3c67c9b33bd236932" => :mavericks
  end

  depends_on "daemontools"
  depends_on "ucspi-tcp"

  def install
    inreplace "hier.c", 'c("/"', "c(auto_home"
    inreplace "dnscache-conf.c", "/etc/dnsroots", "#{etc}/dnsroots"

    # Write these variables ourselves.
    rm %w[conf-home conf-ld conf-cc]
    (buildpath/"conf-home").write prefix
    (buildpath/"conf-ld").write "gcc"

    if MacOS::CLT.installed?
      (buildpath/"conf-cc").write "gcc -O2 -include /usr/include/errno.h"
    else
      (buildpath/"conf-cc").write "gcc -O2 -include #{MacOS.sdk_path}/usr/include/errno.h"
    end

    bin.mkpath
    (prefix/"etc").mkpath # Otherwise "file does not exist"
    system "make", "setup", "check"
  end

  test do
    assert_match /localhost/, shell_output("#{bin}/dnsname 127.0.0.1")
  end
end
