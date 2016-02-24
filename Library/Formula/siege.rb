class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-3.1.3.tar.gz"
  sha256 "4d3932ea23cbf6d1d22df7c7ee6e7a6bc9f591b604ab582393eeb62f393f5a33"

  bottle do
    sha256 "b6fd654eff78d2b326e8308f3c779300d2dbf034853d13dddeee26e36388497a" => :el_capitan
    sha256 "1d794a569a64cc6158fabe7bf8940db6aa0f6153d50b2e71457bfc13e4918a24" => :yosemite
    sha256 "a78857a335916fafa6bf143d428291dcff7057e061a99bc154aee35fd17b13e9" => :mavericks
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
