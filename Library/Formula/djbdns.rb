class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  bottle do
    sha256 "bc3e65f5e6890d7d0713f6e6b402e737df5ae87e20c88a031884c8adad363102" => :yosemite
    sha256 "ee0883572c4143830c16484e2ad1af53894295b4ca118a9080b4305255cc9d34" => :mavericks
    sha256 "36a136abcc2964b8298335f76db02306f3f1ee70310a146af75a6dae0c1d0f88" => :mountain_lion
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
