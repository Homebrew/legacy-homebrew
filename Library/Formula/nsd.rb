require 'formula'

class Nsd < Formula
  homepage 'http://www.nlnetlabs.nl/projects/nsd/'
  url 'http://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.1.tar.gz'
  sha1 '11ca8a7bef74500f486db5deac994fdf3dec7358'

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
