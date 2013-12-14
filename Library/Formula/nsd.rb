require 'formula'

class Nsd < Formula
  homepage 'http://www.nlnetlabs.nl/projects/nsd/'
  url 'http://www.nlnetlabs.nl/downloads/nsd/nsd-4.0.0.tar.gz'
  sha1 'b3ebd669be8e830f62062d12be55242ca41da369'

  option 'without-largefile', 'Disable support for large files'
  option 'without-recvmmsg', 'Disable recvmmsg and sendmmsg'
  option 'with-root-server', 'Allow NSD to run as a root server'
  option 'without-ipv6' , 'Disable IPv6'
  option 'with-bind8-stats', 'Enable BIND8-like NSTATS & XSTATS'
  option 'with-ratelimit', 'Enable rate limiting'
  option 'without-nsec3', 'Disable NSEC3'
  option 'without-minimal-responses', 'Disable response minimization'
  option 'with-draft-rrtypes', 'Enable draft RRtypes'

  depends_on 'libevent'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-libevent=#{HOMEBREW_PREFIX}
    ]

    args << '--disable-largefile' if build.without? 'largefile'
    args << '--disable-recvmmsg' if build.without? 'recvmmsg'
    args << '--enable-root-server' if build.with? 'root-server'
    args << '--disable-ipv6' if build.without? 'ipv6'
    args << '--enable-bind8-stats' if build.with? 'bind8-stats'
    args << '--enable-ratelimit' if build.with? 'ratelimit'
    args << '--disable-nsec3' if build.without? 'nsec3'
    args << '--disable-minimal-responses' if build.without? 'minimal-responses'
    args << '--enable-draft-rrtypes' if build.with? 'draft-rrtypes'

    system "./configure", *args
    system "make install"
  end
end
