class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.6.tar.gz"
  sha256 "88f622055c95d38b9ef3723a240d1d0da35a28d09fe23b601015181a61d7775f"

  bottle do
    sha256 "dd753639f90df74bf6f8421aa032bdd2334a9463f71bdc91e912f4274cfafb1f" => :el_capitan
    sha256 "d16ec152b764291646bbafe3b69d8778fca7e25c9ebc9360b61e12e5726c7528" => :yosemite
    sha256 "086a51e77b7ea6bfaa79c1853a049a2304053a1311da9009fa4c9da607e9caa2" => :mavericks
  end

  option "with-root-server", "Allow NSD to run as a root name server"
  option "with-bind8-stats", "Enable BIND8-like NSTATS & XSTATS"
  option "with-ratelimit", "Enable rate limiting"
  option "with-zone-stats", "Enable per-zone statistics"

  depends_on "libevent"
  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--enable-root-server" if build.with? "root-server"
    args << "--enable-bind8-stats" if build.with? "bind8-stats"
    args << "--enable-ratelimit" if build.with? "ratelimit"
    args << "--enable-zone-stats" if build.with? "zone-stats"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
