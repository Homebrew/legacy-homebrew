require 'formula'

class Nsd < Formula
  homepage 'http://www.nlnetlabs.nl/projects/nsd/'
  url 'http://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.1.tar.gz'
  sha1 '11ca8a7bef74500f486db5deac994fdf3dec7358'

  bottle do
    sha1 "e0b29e8c010ea0e20949e3a7bdf2206136d68e2a" => :yosemite
    sha1 "2648d981e7a399b76a06fa93d7d75d865ca8d816" => :mavericks
    sha1 "a0ec3d813f678d8f83f11011693fcdbed0ebe4f5" => :mountain_lion
  end

  option 'with-root-server', 'Allow NSD to run as a root name server'
  option 'with-bind8-stats', 'Enable BIND8-like NSTATS & XSTATS'
  option 'with-ratelimit', 'Enable rate limiting'
  option 'with-zone-stats', 'Enable per-zone statistics'

  depends_on 'libevent'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
    ]

    args << '--enable-root-server' if build.with? 'root-server'
    args << '--enable-bind8-stats' if build.with? 'bind8-stats'
    args << '--enable-ratelimit' if build.with? 'ratelimit'
    args << '--enable-zone-stats' if build.with? 'zone-stats'

    system "./configure", *args
    system "make install"
  end
end
