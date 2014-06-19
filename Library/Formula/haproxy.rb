require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://www.haproxy.org/download/1.5/src/haproxy-1.5.0.tar.gz'
  sha1 'dc957d93871e4543d1850a144543bcaa26df37a0'

  bottle do
    cellar :any
    sha1 "4f77107fc9067d3f90ff903c9a9142f79746cd20" => :mavericks
    sha1 "c5b6f83b827da688de9008dc20ed3074565f3ef4" => :mountain_lion
    sha1 "8223c6ba3c4eaba367991b17e33efcfc30418d3f" => :lion
  end

  depends_on 'pcre'

  def install
    args = ["TARGET=generic",
            "USE_KQUEUE=1",
            "USE_POLL=1",
            "USE_PCRE=1",
            "USE_OPENSSL=1",
            "USE_ZLIB=1",
            "ADDLIB=-lcrypto",
    ]

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end
end
