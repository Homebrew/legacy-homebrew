class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  url "https://github.com/twitter/twemcache/archive/v2.6.2.tar.gz"
  sha256 "49905ceb89bf5d0fde25fa4b8843b2fe553915c0dc75c813de827bd9c0c85e26"
  head "https://github.com/twitter/twemcache.git"

  option "with-debug", "Debug mode with assertion panics enabled"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "debug"
      ENV.O0
      ENV.append "CFLAGS", "-ggdb3"
      args << "--enable-debug=full"
    end

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"twemcache", "--help"
  end
end
