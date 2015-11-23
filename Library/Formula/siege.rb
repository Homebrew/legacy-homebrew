class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-3.1.0.tar.gz"
  sha256 "f6a104cb2a3ac6c0efb2699649e8c4f8da2b548147bbbb7af2483089e4940e7f"

  bottle do
    sha256 "831198aa901335b0680c87db63f56c4cec905a7a51824361f53aff8b87bf2e79" => :el_capitan
    sha256 "f1456aec75bb9403dcfdb2fc043cfc5721f585d7c16698c79e3f7a6bfc202b59" => :yosemite
    sha256 "c67690422391cb3d2cc27a55930c278cf6a7b7d9e15e2d86d10e58e83b478821" => :mavericks
    sha256 "40a93e1f6e9cb1c9f5c71c29aa1f2612fc6d70eee1a56be6678f1acdc8708499" => :mountain_lion
  end

  depends_on "openssl"

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Mac OS X has only 16K ports available that won't be released until socket
    TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
    Consider reducing in case of available port bottleneck.

    You can check whether this is a problem with netstat:

        # sysctl net.inet.tcp.msl
        net.inet.tcp.msl: 15000

        # sudo sysctl -w net.inet.tcp.msl=1000
        net.inet.tcp.msl: 15000 -> 1000

    Run siege.config to create the ~/.siegerc config file.
    EOS
  end

  test do
    system "#{bin}/siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
