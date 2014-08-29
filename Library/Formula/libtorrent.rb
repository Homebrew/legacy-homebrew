require "formula"

class Libtorrent < Formula
  homepage "http://libtorrent.rakshasa.no/"
  url "http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.4.tar.gz"
  sha1 "3a3ca87054d020bc376abe2c1ea15bbbaef31131"

  bottle do
    cellar :any
    sha1 "e64f87dc56f811ed638e21d6010efd671c461d1e" => :mavericks
    sha1 "328d903212207eea0a9117eee3edbfb707612438" => :mountain_lion
    sha1 "0061da39b678f0c0859de0ebbae14f5ad70d104a" => :lion
  end

  depends_on "pkg-config" => :build

  # https://github.com/Homebrew/homebrew/issues/24132
  fails_with :clang do
    cause "Causes segfaults at startup/at random."
  end

  def install
    # Currently can't build against libc++; see:
    # https://github.com/mxcl/homebrew/issues/23483
    # https://github.com/rakshasa/libtorrent/issues/47
    ENV.libstdcxx if ENV.compiler == :clang

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-kqueue",
                          "--enable-ipv6"
    system "make"
    system "make install"
  end
end
