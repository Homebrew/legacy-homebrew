require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.25.tar.gz'
  sha1 'f5c7dcaf0e8190f86e58b8e106dbc53609beaacd'

  devel do
    url 'http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev26.tar.gz'
    sha1 'cab0d9b73dff87d159bf1ee64a127bacf88ac87f'
    version '1.5-dev26'

    # we can remove it when a new version is released
    # don't use type "uint" which is not portable
    patch do
      url "http://git.1wt.eu/web?p=haproxy.git;a=commitdiff_plain;h=c874653bb45b101f50ea710576c7b47766874d1c"
      sha1 "ed16bdb9096c09b79135d5d43db9ef8581decb02"
    end
  end

  depends_on 'pcre'

  def install
    args = ["TARGET=generic",
            "USE_KQUEUE=1",
            "USE_POLL=1",
            "USE_PCRE=1"]

    if build.devel?
      args << "USE_OPENSSL=1"
      args << "USE_ZLIB=1"
      args << "ADDLIB=-lcrypto"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end
end
