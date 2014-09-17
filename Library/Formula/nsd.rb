require 'formula'

class Nsd < Formula
  homepage 'http://www.nlnetlabs.nl/projects/nsd/'
  url 'http://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.0.tar.gz'
  sha1 'cb4ec496eaec5bfbd5b9f4b361da2a0a79d17030'

  option 'with-root-server', 'Allow NSD to run as a root name server'
  option 'with-bind8-stats', 'Enable BIND8-like NSTATS & XSTATS'
  option 'with-ratelimit', 'Enable rate limiting'

  depends_on 'libevent'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
    ]

    args << '--enable-root-server' if build.with? 'root-server'
    args << '--enable-bind8-stats' if build.with? 'bind8-stats'
    args << '--enable-ratelimit' if build.with? 'ratelimit'

    system "./configure", *args
    system "make install"
  end
end
