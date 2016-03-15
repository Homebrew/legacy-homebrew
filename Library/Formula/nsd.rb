class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.9.tar.gz"
  sha256 "b811224d635331de741f1723aefc41adda0a0a3a499ec310aa01dd3b4b95c8f2"

  bottle do
    sha256 "54565831514a3840894276ef82bf4ff59cd5465786a6d92b38cb98fa2a992a82" => :el_capitan
    sha256 "feb1f6612176f82d215c3d8ad6263ea006cb4794ce43638ca355b88fcb7dc94a" => :yosemite
    sha256 "86619958e0f5ce2e02b9088060beed1dbdbe51ba0eb041758bfea9e409f5b89c" => :mavericks
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
