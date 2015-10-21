class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.6.tar.gz"
  sha256 "88f622055c95d38b9ef3723a240d1d0da35a28d09fe23b601015181a61d7775f"

  bottle do
    sha256 "b58ca9838a0dc0dfc8a63a37d76688c182bbc57cc7a7c72296e09e05b82fa7a0" => :el_capitan
    sha256 "a95e06a2834c46ed2ed5de8a7a9bd7f51a0a26934dcf730a15e0ee1790fb1edc" => :yosemite
    sha256 "a3002e6cd9f5220e4bc407821bcf7306fce681f8922e240f6f8e6a4310607b82" => :mavericks
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
