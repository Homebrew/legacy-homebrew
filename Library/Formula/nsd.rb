require 'formula'

class Nsd < Formula
  homepage 'http://www.nlnetlabs.nl/projects/nsd/'
  url 'http://www.nlnetlabs.nl/downloads/nsd/nsd-4.0.0.tar.gz'
  sha1 'b3ebd669be8e830f62062d12be55242ca41da369'

  option 'with-root-server', 'Allow NSD to run as a root server'
  option 'with-bind8-stats', 'Enable BIND8-like NSTATS & XSTATS'
  option 'with-ratelimit', 'Enable rate limiting'

  depends_on 'libevent'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{HOMEBREW_PREFIX}
    ]

    args << '--enable-root-server' if build.with? 'root-server'
    args << '--enable-bind8-stats' if build.with? 'bind8-stats'
    args << '--enable-ratelimit' if build.with? 'ratelimit'

    system "./configure", *args
    system "make install"
  end
end
