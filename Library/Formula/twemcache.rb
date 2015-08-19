class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  head "https://github.com/twitter/twemcache.git"
  url "https://github.com/twitter/twemcache/archive/v2.6.0.tar.gz"
  sha256 "6e0e9361bda46bdaa577c7eed6cd829aeca442b2c3b4f84b250039c86027ce05"

  option "enable-debug", "Debug mode with assertion panics enabled"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    # After the deprecation of GitHub Downloads, we don't have distribution
    # downloads anymore.  Everything is now a repository download from version
    # tags.
    system "autoreconf", "-ivf"

    args = ["--prefix=#{prefix}"]
    if build.include? "enable-debug"
      ENV.O0
      ENV.append "CFLAGS", "-ggdb3"
      args << "--enable-debug=full"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
